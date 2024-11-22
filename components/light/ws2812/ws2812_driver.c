#include "ws2812_driver.h"

static lp_rmt_channel_t ws2812RmtDefaultChannel;
static ws2812_buffer_t ws2812Buffer;

int ws2812_driver_init(void) {

    lp_rmt_init_device();
    lp_rmt_create_default_tx_channel(&ws2812RmtDefaultChannel);
    
    lp_rmt_config_tx_channel(&ws2812RmtDefaultChannel);

    ws2812RmtDefaultChannel.bit0 = (rmt_symbol_word_t) {
        .level0 = 1,
        // XTAL_CLK_FREQ
        .duration0 = 16,   // 0.4us (static calculation, use XTAL_CLK_FREQ)
        // .duration0 = 0.4 * ws2812RmtDefaultChannel.realClkResolutionHz / 1000000,   // 0.3us (dynamic calculation)
        .level1 = 0,
        // .duration1 = 0.8 * ws2812RmtDefaultChannel.realClkResolutionHz / 1000000    // 0.9us (dynamic calculation)
        // XTAL_CLK_FREQ
        .duration1 = 32    // 0.8us (static calculation, use XTAL_CLK_FREQ)
    };
    ws2812RmtDefaultChannel.bit1 = (rmt_symbol_word_t) {
        .level0 = 1,
        // XTAL_CLK_FREQ
        .duration0 = 32,   // 0.8us (static calculation, use XTAL_CLK_FREQ)
        // .duration0 = 0.8 * ws2812RmtDefaultChannel.realClkResolutionHz / 1000000,   // 0.9us (dynamic calculation)
        .level1 = 0,
        // .duration1 = 0.4 * ws2812RmtDefaultChannel.realClkResolutionHz / 1000000    // 0.3us (dynamic calculation)
        .duration1 = 16    // 0.4us (static calculation, use XTAL_CLK_FREQ)
    };
    ws2812RmtDefaultChannel.msbFirst = true;

    // set default brightness for hsv color space
    ws2812Buffer.BrightBuffer = 10;

    return 0;
}

void ws2812_driver_deinit(void) {
    lp_rmt_deinit_device();
}

int ws2812_driver_set_channel(uint8_t channel, uint8_t val) {
    // As for WS2812, we define the unit of speed as ms (milli second)
    switch (channel) {
        case WS2812_CHANNEL_RED:
            ws2812Buffer.RGBBuffer.red = val;
        break;
        case WS2812_CHANNEL_GREEN:
            ws2812Buffer.RGBBuffer.green = val;
        break;
        case WS2812_CHANNEL_BLUE:
            ws2812Buffer.RGBBuffer.blue = val;
        break;
        case WS2812_CHANNEL_COLD:
            ws2812Buffer.CWBuffer.cold = val;
        break;
        case WS2812_CHANNEL_WARM:
            ws2812Buffer.CWBuffer.warm = val;
        break;
        case WS2812_CHANNEL_BRIGHTNESS:
            ws2812Buffer.BrightBuffer = val;
        break;
        default:
            return 1;
        break;
    }
    ws2812Buffer.lastUpdatedChannel = channel;
    return 0;
}

int ws2812_driver_regist_channel(uint8_t channel, gpio_num_t gpio) {
    // for WS2812, do nothing
    return 0;
}

int ws2812_driver_update_channels(void) {
    switch (ws2812Buffer.lastUpdatedChannel) {
        case WS2812_CHANNEL_RED:
        case WS2812_CHANNEL_GREEN:
        case WS2812_CHANNEL_BLUE:
            // use RGB value as final reference
        break;
        case WS2812_CHANNEL_COLD:
        case WS2812_CHANNEL_WARM:
        case WS2812_CHANNEL_BRIGHTNESS:
            // use CW value as final reference
            cw_to_hsv(ws2812Buffer.CWBuffer, &ws2812Buffer.HSBuffer);
            hsv_to_rgb(ws2812Buffer.HSBuffer, ws2812Buffer.BrightBuffer, &ws2812Buffer.RGBBuffer);
        break;
        default:
            return 1;
        break;
    }

    // Copy color settings to RMT buffer
    ws2812Buffer.RMTBufferGRB[0] = ws2812Buffer.RGBBuffer.green;
    ws2812Buffer.RMTBufferGRB[1] = ws2812Buffer.RGBBuffer.red;
    ws2812Buffer.RMTBufferGRB[2] = ws2812Buffer.RGBBuffer.blue;
    // update color settings
    lp_rmt_send_bytes(ws2812Buffer.RMTBufferGRB, 24, &ws2812RmtDefaultChannel);

    return 0;
}
