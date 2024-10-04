return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.root_dir = function(fname)
      local loaded_root_pattern = require("lspconfig.util").root_pattern
      local root_files = {
        -- Multi-module projects
        { ".git", "build.gradle", "build.gradle.kts" },
        -- Single-module projects
        {
          "build.xml", -- Ant
          "pom.xml", -- Maven
          "settings.gradle", -- Gradle
          "settings.gradle.kts", -- Gradle
          "*.iml", -- idea
          ".classpath",
        },
      }

      for _, patterns in ipairs(root_files) do
        local root = loaded_root_pattern(unpack(patterns))(fname)
        if root then
          return root
        end
      end
    end
  end,
}
