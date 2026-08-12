return {
  {
    'sphamba/smear-cursor.nvim',
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = true,
      smear_insert_mode = true,
      transparent_bg_fallback_color = '#24283b',
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      damping = 0.95,
      damping_insert_mode = 0.95,
      distance_stop_animating = 0.5,
      hide_target_hack = true,
      never_draw_over_target = true,
    },
  },
}
