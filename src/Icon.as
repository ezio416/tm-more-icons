// c 2025-07-28
// m 2025-08-13

class Icon {
    uint8[] bytes;
    string  bytesStr;
    uint    codePoint;
    string  name;
    string  icon;

    Icon(const string&in name, const string&in icon) {
        this.name = name;
        this.icon = icon;

        for (int i = 0; i < icon.Length; i++) {
            bytes.InsertLast(icon[i]);

            if (i > 0) {
                bytesStr += " ";
            }
            bytesStr += Text::Format("%X", icon[i]);
        }

        codePoint = UTF8ToCodepoint(bytes);
    }
}
