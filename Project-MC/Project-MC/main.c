#include <mega164a.h>
#include <delay.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>

#define LCD_I2C_ADDR 0x27
#define LCD_BACKLIGHT 0x08

#ifndef TWEN
    #define TWSTO 4
    #define TWSTA 5
    #define TWEN  2
    #define TWINT 7
#endif

#define F_CPU 20000000UL //freq
#define BAUD 9600 //UART Baud Rate
#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1)
#define RL_VALUE 10000.0 //Load resistance of the sensor
#define R0_VALUE 8000.0  //Aprx sensor resistance in clean air
#define A_CONST 0.4
#define B_CONST 0.4 //ct for calibration
#define ADC_MAX 1023

// init UART
void uart_init(void) {
    UBRR0H = (unsigned char)(UBRR_VALUE >> 8);
    UBRR0L = (unsigned char)(UBRR_VALUE & 0xFF);
    UCSR0B = (1 << 3);
    UCSR0C = (1 << 2) | (1 << 1);
}

void uart_send(char c) {
    while (!(UCSR0A & (1 << 5)));
    UDR0 = c;
}

void uart_print(const char *str) {
    while (*str) uart_send(*str++);
}

//init AdC

void adc_init(void) {
    ADMUX = (1 << 6);
    ADCSRA = (1 << 7) | (1 << 2) | (1 << 1);
}

uint16_t adc_read(void) {
    ADCSRA |= (1 << 6);           //start conv
    while (ADCSRA & (1 << 6));
    return ADCW;
}

//i2c for display
void I2C_Write(uint8_t data) {
    TWDR = data;
    TWCR = (1 << TWEN) | (1 << TWINT);
    while (!(TWCR & (1 << TWINT)));
}

void LCD_I2C_Start() {
    TWCR = (1 << TWSTA) | (1 << TWEN) | (1 << TWINT);
    while (!(TWCR & (1 << TWINT)));
}

void LCD_I2C_Stop() {
    TWCR = (1 << TWSTO) | (1 << TWEN) | (1 << TWINT);
    delay_us(10);
}
///4bit
void LCD_I2C_Send(uint8_t data) {
    I2C_Write(data);
}

void LCD_Send4Bits(uint8_t data) {
    LCD_I2C_Send(data | LCD_BACKLIGHT | 0x04);
    delay_us(1);
    LCD_I2C_Send(data | LCD_BACKLIGHT);
    delay_us(50);
}

void LCD_WriteCmd(uint8_t cmd) {
    uint8_t high = cmd & 0xF0;
    uint8_t low = (cmd << 4) & 0xF0;
    LCD_I2C_Start();
    I2C_Write(LCD_I2C_ADDR << 1);
    LCD_Send4Bits(high);
    LCD_Send4Bits(low);
    LCD_I2C_Stop();
    delay_ms(2);
}

void LCD_WriteData(uint8_t data) {
    uint8_t high = (data & 0xF0) | 0x01;
    uint8_t low = ((data << 4) & 0xF0) | 0x01;
    LCD_I2C_Start();
    I2C_Write(LCD_I2C_ADDR << 1);
    LCD_Send4Bits(high);
    LCD_Send4Bits(low);
    LCD_I2C_Stop();
    delay_ms(2);
}

void LCD_Clear() {
    LCD_WriteCmd(0x01);
    delay_ms(2);
}

void LCD_SetCursor(uint8_t col, uint8_t row) {
    uint8_t addr = (row == 0) ? 0x80 + col : 0xC0 + col;
    LCD_WriteCmd(addr);
}

void LCD_Print(char *str) {
    while (*str) {
        LCD_WriteData(*str++);
    }
}

//lcd init
void LCD_Init() {
    TWSR = 0x00;
    TWBR = 32;
    delay_ms(50);

    LCD_WriteCmd(0x33);
    LCD_WriteCmd(0x32);
    LCD_WriteCmd(0x28);
    LCD_WriteCmd(0x0C);
    LCD_WriteCmd(0x06);
    LCD_WriteCmd(0x01);
    delay_ms(5);
}
//bargraph

void LCD_DrawBargraph(float value, float max_value) {
    uint8_t bar_length = 16;
    uint8_t filled = 0;
    uint8_t i;

    if (value <= 0.0f) {
        filled = 0; // Empty bar at 0
    } else if (value >= max_value) {
        filled = bar_length; // Full bar at or above max_value
    } else {
        filled = (uint8_t)((value / max_value) * bar_length + 0.5f);
    }

    for (i = 0; i < bar_length; i++) {
        if (i < filled) LCD_WriteData(0xFF);  //solid block
        else LCD_WriteData(' ');
    }
}

void main(void) {
    char buffer[32];
    uint16_t adc_val;
    float rs, rs_r0, ppm, mg_per_l;

    uart_init();
    adc_init();
    LCD_Init();

    while (1) {
        adc_val = adc_read(); // read adc value

        if (adc_val == 0) {
            mg_per_l = 0.0;  //prevent div by 0
        } else {
            rs = RL_VALUE * ((float)ADC_MAX / adc_val - 1.0); //sensor resistance Rs from adc
            rs_r0 = rs / R0_VALUE;                            //normalize rs
            ppm = pow(rs_r0 / A_CONST, 1.0 / -B_CONST);       //gas concentration in ppm(parts per mil)
            mg_per_l = ppm * 1.884;                           //convert ppm to mg/l
        }

        if (mg_per_l < 0.0) mg_per_l = 0.0;
        if (mg_per_l > 10.0) mg_per_l = 10.0;

        LCD_Clear();
        LCD_SetCursor(0, 0);
        LCD_Print("Alcohol Level:");

        LCD_SetCursor(0, 1);
        LCD_DrawBargraph(mg_per_l, 1.0); // bar max at 1.0mg/L

        sprintf(buffer, "Alcohol: %.2fmg/L\r\n", mg_per_l);
        uart_print(buffer);

        delay_ms(1000);
    }
}
