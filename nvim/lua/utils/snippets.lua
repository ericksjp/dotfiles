local ls = require("luasnip")
local rep = require("luasnip.extras").rep
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

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

-- ////////////////////////

local function gettag()
  return vim.fn.fnamemodify(vim.fn.expand("%:h"), ":t")
end

local function getid()
  return vim.fn.expand("%:t:r")
end

ls.add_snippets("markdown", {
s("aimg", {
    t("!["),
    i(0, "alt text"),
    t("](../../assets/"),
    i(1, "image"),
    t(")"),
  }),
  s("ln", {
    t("[["),
    i(1),
    t("]]"),
  }),
  s("temp", {
    t("---"),
    t({ "", "id: " }),
    f(getid, {}),
    t({ "", "date: " }),
    f(function()
      return os.date("%Y-%m-%d")
    end, {}),
    t({ "", "tags:", "  - " }),
    f(gettag, {}),
    t({ "", "hubs:", "urls:", "---", "", "# Title" }),
    i(0), -- Final cursor position
  }),
})

-- ////////////////////////

ls.add_snippets("javascript", {
  s("imd", {
    t("import "),
    i(1, "moduleName"),
    t(' from "'),
    i(2, "source"),
    t('";'),
  }),
})

local nobody = {
  rg = "GET",
  rd = "DELETE",
}

local withbody = {
  rpo = "POST",
  rpa = "PATCH",
  rpu = "PUT",
}

local httpSnippets = {}

for k, v in pairs(nobody) do
  table.insert(
    httpSnippets,
    s(k, {
      t(v),
      t(" "),
      i(1, "URL"),
      t({ "", "" }),
      i(2),
      t({ "", "###", "", "" }),
    })
  )
end

for k, v in pairs(withbody) do
  table.insert(
    httpSnippets,
    s(k, {
      t(v),
      t(" "),
      i(1, "URL"),
      t({ "", "Content-Type: application/json", "" }),
      i(2),
      t({ "", "" }),
      t({ "{", "\t" }),
      i(3),
      t({ "", "" }),
      t({ "}", "" }),
      i(4),
      t({ "", "###", "" }),
    })
  )
end

ls.add_snippets("http", httpSnippets)

ls.add_snippets("http", {
  s("new", {
    t({ "", "###", "", "" }),
  }),
  s("field", {
    t('"'),
    i(1, "key"),
    t('": '),
    i(2, "value"),
  }),
  s("head", {
    t(""),
    i(1, "header"),
    t(": "),
    i(2, "value"),
    t(""),
    t(),
  }),
  s("var", {
    t("{{"),
    i(1, "variable"),
    t("}}"),
  }),
  s("jscript", {
    t({ "> {%", "" }),
    t("\tconst body = response.body"),
    t({ "", "\t" }),
    i(1),
    t({ "", "", "%}" }),
  }),
})

ls.add_snippets("java", {
  s("jfprivate", {
    t("private "),
    i(1, "String"),
    t(" "),
    i(2, "name"),
    t(""),
    t(";"),
  }),
  s("jfpublic", {
    t("public "),
    i(1, "String"),
    t(" "),
    i(2, "name"),
    t(""),
    t(";"),
  }),
  s("jfprotected", {
    t("protected "),
    i(1, "String"),
    t(" "),
    i(2, "name"),
    t(""),
    t(";"),
  }),
  s("jsfprivate", {
    t("private static "),
    i(1, "String"),
    t(" "),
    i(2, "name"),
    t(""),
    t(";"),
  }),
  s("jsfpublic", {
    t("public static "),
    i(1, "String"),
    t(" "),
    i(2, "name"),
    t(""),
    t(";"),
  }),

  s("jmprivate", {
    t("private "),
    i(1, "void"),
    t(" "),
    i(2, "name"),
    t("("),
    i(3),
    t({ ") {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),
  s("jmpublic", {
    t("public "),
    i(1, "void"),
    t(" "),
    i(2, "name"),
    t("("),
    i(3),
    t({ ") {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),
  s("jsmprivate", {
    t("private static "),
    i(1, "Type"),
    t(" "),
    i(2, "name"),
    t("("),
    i(3),
    t({ ") {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),
  s("jsmpublic", {
    t("public static "),
    i(1, "void"),
    t(" "),
    i(2, "name"),
    t("("),
    i(3),
    t({ ") {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),
  s("jmprotected", {
    t("protected "),
    i(1, "void"),
    t(" "),
    i(2, "name"),
    t("("),
    i(3),
    t({ ") {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),
})

return ls
