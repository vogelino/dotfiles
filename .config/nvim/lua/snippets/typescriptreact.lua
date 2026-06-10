local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

return {
  s("stry", {
    t({ 'import type { ComponentProps } from "react";', "" }),
    t('import { '),
    i(1, "ComponentName"),
    t(' } from "../'),
    rep(1),
    t({ '";', "" }),
    t({ 'import type { Meta, StoryObj } from "@storybook/nextjs";', "", "" }),
    t("type StoryProps = ComponentProps<typeof "),
    rep(1),
    t({ ">;", "", "" }),
    t("const meta: Meta<StoryProps> = {"),
    t({ "", '  title: "Components/Composites/' }),
    rep(1),
    t({ '",', "" }),
    t("  component: "),
    rep(1),
    t({ ",", "" }),
    t({ '  parameters: { layout: "centered" },', "" }),
    t({ "};", "", "" }),
    t({ "export default meta;", "", "" }),
    t({ "type Story = StoryObj<StoryProps>;", "", "" }),
    t("export const "),
    i(2, "Default"),
    t(": Story = {"),
    i(0),
    t("};"),
  }),
}
