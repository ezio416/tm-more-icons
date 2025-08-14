// c 2025-07-28
// m 2025-08-13

void RenderWindow() {
    const float scale = UI::GetScale();

    bool changed;
    filter = UI::InputText("filter", filter, changed);
    if (changed) {
        Filter();
    }

    if (UI::BeginTable("##table-icons", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(vec3(), 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("##spacer",   UI::TableColumnFlags::WidthFixed, scale * 0.0f);
        UI::TableSetupColumn("icon",       UI::TableColumnFlags::WidthFixed, scale * 30.0f);
        UI::TableSetupColumn("name");
        UI::TableSetupColumn("code point", UI::TableColumnFlags::WidthFixed, scale * 70.0f);
        UI::TableSetupColumn("bytes",      UI::TableColumnFlags::WidthFixed, scale * 70.0f);
        UI::TableHeadersRow();

        UI::ListClipper clipper(iconsFiltered.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                Icon@ icon = iconsFiltered[i];

                UI::TableNextRow();

                UI::TableSetColumnIndex(1);
                if (UI::Selectable(icon.icon, false)) {
                    IO::SetClipboard(icon.icon);
                }

                UI::TableNextColumn();
                if (UI::Selectable(icon.name, false)) {
                    IO::SetClipboard(icon.name);
                }

                UI::TableNextColumn();
                const string cp = "\\u" + Text::Format("%X", icon.codePoint);
                if (UI::Selectable(cp, false)) {
                    IO::SetClipboard(cp);
                }

                UI::TableNextColumn();
                if (UI::Selectable(icon.bytesStr, false)) {
                    IO::SetClipboard(icon.bytesStr);
                }
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}
