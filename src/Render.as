const int fixed = UI::TableColumnFlags::WidthFixed;
const int noSort = UI::TableColumnFlags::NoSort;

void RenderWindow() {
    const float scale = UI::GetScale();
    const string highlightColor = Text::FormatGameColor(S_HighlightColor);

    bool changed;
    filter = UI::InputText("filter", filter, changed);
    if (changed) {
        Filter();
    }

    UI::SameLine();
    UI::Text("(" + iconsFiltered.Length + " results)");

    const int flags = 0
        | UI::TableFlags::RowBg
        | UI::TableFlags::ScrollY
        | UI::TableFlags::Sortable
    ;

    if (UI::BeginTable("##table-icons", 5, flags)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(vec3(), 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("##spacer",   fixed | noSort, scale * 0.0f);
        UI::TableSetupColumn("icon",       fixed | noSort, scale * 30.0f);
        UI::TableSetupColumn("name");
        UI::TableSetupColumn("code point", fixed,          scale * 80.0f);
        UI::TableSetupColumn("bytes",      fixed | noSort, scale * 70.0f);
        UI::TableHeadersRow();

        UI::TableSortSpecs@ sortSpecs = UI::TableGetSortSpecs();
        if (true
            and sortSpecs !is null
            and sortSpecs.Dirty
        ) {
            UI::TableColumnSortSpecs[]@ colSpecs = sortSpecs.Specs;
            if (true
                and colSpecs !is null
                and colSpecs.Length > 0
            ) {
                if (colSpecs[0].SortDirection == UI::SortDirection::Ascending) {
                    if (colSpecs[0].ColumnIndex == 2) {
                        sortMethod = SortMethod::NameAsc;
                    } else if (colSpecs[0].ColumnIndex == 3) {
                        sortMethod = SortMethod::CodePointAsc;
                    }
                } else {
                    if (colSpecs[0].ColumnIndex == 2) {
                        sortMethod = SortMethod::NameDesc;
                    } else if (colSpecs[0].ColumnIndex == 3) {
                        sortMethod = SortMethod::CodePointDesc;
                    }
                }
            }

            Sort();
            sortSpecs.Dirty = false;
        }

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
                string name = icon.name;
                if (filter.Length > 0) {
                    name = Regex::Replace(
                        name,
                        "(" + filter + ")",
                        "\\$" + highlightColor + "$1\\$G",
                        Regex::Flags::CaseInsensitive
                    );
                }
                if (UI::Selectable(name, false)) {
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
