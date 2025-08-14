// c 2025-07-28
// m 2025-08-13

const string  pluginColor = "\\$F0A";
const string  pluginIcon  = Icons::Info;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

string filter;
Icon@[] icons;
Icon@[] iconsFiltered;

void Main() {
    dictionary@ allIcons = Icons::GetAll();
    string[]@ keys = allIcons.GetKeys();
    for (uint i = 0; i < keys.Length; i++) {
        icons.InsertLast(Icon("Icons::" + keys[i], string(allIcons[keys[i]])));
    }

    Filter();
}

void Render() {
    if (false
        or !S_Enabled
        or (true
            and S_HideWithGame
            and !UI::IsGameUIVisible()
        )
        or (true
            and S_HideWithOP
            and !UI::IsOverlayShown()
        )
    ) {
        return;
    }

    if (UI::Begin(pluginTitle + "###main-" + pluginMeta.ID, S_Enabled, UI::WindowFlags::None)) {
        RenderWindow();
    }
    UI::End();
}

void RenderMenu() {
    if (UI::MenuItem(pluginTitle, "", S_Enabled)) {
        S_Enabled = !S_Enabled;
    }
}
