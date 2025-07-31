#include <twi.h>
#include <delay.h>
#include "twi_lcd.h"

#define LCD_ADDR 0x4E  // Adjust if your LCD I2C address differs

void lcd_send_cmd(unsigned char cmd) {
    unsigned char data_u, data_l;
    data_u = cmd & 0xF0;
    data_l = (cmd << 4) & 0xF0;

    twi_start();
    twi_write(LCD_ADDR);
    twi_write(data_u | 0x0C);  // EN=1, RS=0
    twi_write(data_u | 0x08);  // EN=0
    twi_write(data_l | 0x0C);
    twi_write(data_l | 0x08);
    twi_stop();
    delay_ms(2);
}

void lcd_send_data(unsigned char data) {
    unsigned char data_u, data_l;
    data_u = data & 0xF0;
    data_l = (data << 4) & 0xF0;

    twi_start();
    twi_write(LCD_ADDR);
    twi_write(data_u | 0x0D);  // EN=1, RS=1
    twi_write(data_u | 0x09);  // EN=0
    twi_write(data_l | 0x0D);
    twi_write(data_l | 0x09);
    twi_stop();
    delay_ms(2);
}

void lcd_init(void) {
    delay_ms(50);
    lcd_send_cmd(0x33);
    lcd_send_cmd(0x32);
    lcd_send_cmd(0x28); // 4-bit mode, 2 lines, 5x7 font
    lcd_send_cmd(0x0C); // Display ON, Cursor OFF
    lcd_send_cmd(0x06); // Entry mode
    lcd_send_cmd(0x01); // Clear display
    delay_ms(2);
}

void lcd_clear(void) {
    lcd_send_cmd(0x01);
    delay_ms(2);
}

void lcd_gotoxy(unsigned char x, unsigned char y) {
    lcd_send_cmd(0x80 + (0x40 * y) + x);
}

void lcd_puts(char *str) {
    while (*str) {
        lcd_send_data(*str++);
    }
}
