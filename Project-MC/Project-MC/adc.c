#include <mega164a.h>
#include "adc.h"

unsigned int read_adc(unsigned char channel)
{
    ADMUX = (ADMUX & 0xF0) | (channel & 0x0F);
    ADCSRA |= 0x40;
    while (ADCSRA & 0x40);
    return ADCW;
}

float get_voltage(unsigned char channel)
{
    unsigned int adc_value = read_adc(channel);
    return (adc_value / 1023.0) * 5.0;
}
