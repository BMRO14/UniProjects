#ifndef TWI_LCD_H
#define TWI_LCD_H

void lcd_init(void);
void lcd_clear(void);
void lcd_gotoxy(unsigned char x, unsigned char y);
void lcd_puts(char *str);

#endif
