#include <zmk/keymap.h>

zmk_keymap_layer_index_t zmk_keymap_highest_layer_active(void) {
    return 0;
}

int zmk_keymap_layer_activate(zmk_keymap_layer_id_t layer) {
    return 0;
}

int zmk_keymap_layer_deactivate(zmk_keymap_layer_id_t layer) {
    return 0;
}
