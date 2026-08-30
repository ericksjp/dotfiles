return {
  "chrisgrieser/nvim-recorder",
  -- dependencies = "rcarriga/nvim-notify", -- optional
  opts = {
    slots = { "a", "b", "c", "d" },
    lessNotifications = true,
    logLevel = false,
    mapping = {
      startStopRecording = "qq",
      playMacro = "qp",
      switchSlot = "qn",
      deleteAllMacros = "qe",
      editMacro = "qm",
    },
  },
}
