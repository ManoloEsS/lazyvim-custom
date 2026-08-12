return {
  {
    'nvim-orgmode/orgmode',
    ft = 'org',
    dependencies = {
      {
        'nvim-orgmode/org-bullets.nvim',
        opts = {},
      },
    },
    config = function()
      require('orgmode').setup({
        org_agenda_files = '~/org/**/*',
        org_default_notes_file = '~/org/refile.org',
        org_capture_templates = {
          d = {
            description = 'Dev journal entry',
            template = '**** %^{Topic}\n***** %U %?',
            target = '~/org/dev-journal.org',
            datetree = true,
          },
        },
        org_babel_default_header_args = {
          [':tangle'] = 'no',
          [':noweb'] = 'no',
        },
      })
    end,
  },
}
