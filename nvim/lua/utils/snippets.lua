local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
  s("ff", {
    t({ "function()", "\t" }),
    i(1),
    t({ "", "end" }),
  }),
})

ls.add_snippets("prisma", {
  s("model", {
    t("model "),
    i(1),
    t({ " {", "\t" }),
    i(2),
    t({ "\t", "}" }),
  }),
})

return ls
