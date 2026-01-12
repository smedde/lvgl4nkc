#include <stdio.h>
#include "../../nkc_common/nkc/nkc.h"	
#include "../../m68k-elf/include/sys/m68k.h"

#include "./lvgl/lvgl.h"

#define FB_ADDR   ((uint8_t *)0x800000)
#define LV_HOR_RES_MAX   512
#define LV_VER_RES_MAX   256

int tick = 0;

void doTick() {   
    tick++;           //for debug
    lv_tick_inc(5);   //Call this every 5 ms from a timer interrupt
}

void hardware_init() {

    ENABLE_CPU_INTERRUPTS;
    gp_clearscreen();  //set video memory to black for all 4 pages
    _clock(&doTick);
}

void my_disp_flush(lv_display_t *disp,
                   const lv_area_t *area,
                   uint8_t *px_map)
{
    
    printf("%s\n", "disp_flush");

    /* Copy px_map to your framebuffer here */

    /* Example for linear framebuffer (pseudo-code):
       for(y=area->y1; y<=area->y2; y++)
         memcpy(fb + y*XRES + area->x1,
                px_map,
                (area->x2-area->x1+1));
    */

    lv_display_flush_ready(disp);
}




int main(int argc, char* argv[]) {

    hardware_init();

    /* --------- Display buffer --------- */
    static lv_color_t buf1[LV_HOR_RES_MAX * 10];
    static lv_display_t *disp;

    printf("%s\n", "Hello from LVGL...");

    //to do
    printf("%s %p\n", "GDP video memory at : ", (void*) 0);
    printf("%s %p\n", "LVGL frame buffer at: ", (void*) 0);
    printf("%s %p\n", "LVGL heap at: ",         (void*) 0);
    printf("%s %p\n", "LVGL heap size: ",       (void*) 0);

    //lv_port_disp_init();  //needed ?

    printf("%s\n", "do lv_init...");
    lv_init();

    printf("%s\n", "do lv__display_create...");
    disp = lv_display_create(LV_HOR_RES_MAX, LV_VER_RES_MAX);
    printf("%s %p\n", "disp: ",       (void*) disp);


    lv_display_set_flush_cb(disp, my_disp_flush);

    lv_display_set_buffers(
            disp,
            buf1,
            NULL,
            sizeof(buf1),
            LV_DISPLAY_RENDER_MODE_PARTIAL
    );

    /* Create UI */
    //lv_obj_t *label = lv_label_create(lv_scr_act());
    //lv_label_set_text(label, "Hello LVGL");
    //lv_obj_align(label, LV_ALIGN_CENTER, 0, 0);

    while (1) {

        DISABLE_CPU_INTERRUPTS;
        if ((tick % 10) == 0) {
            printf("%s %i\n", "ticks:", tick);
        }
        ENABLE_CPU_INTERRUPTS;

        lv_timer_handler();   /* must be called periodically */
    }

    printf("%s\n", "...bye !");

	return 0;

}