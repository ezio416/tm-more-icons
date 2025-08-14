// c 2025-08-13
// m 2025-08-13

void Filter() {
    if (filter.Length == 0) {
        iconsFiltered = icons;
    } else {
        iconsFiltered = {};
        for (uint i = 0; i < icons.Length; i++) {
            if (icons[i].name.Replace("Icons::", "").ToLower().Contains(filter.ToLower())) {
                iconsFiltered.InsertLast(icons[i]);
            }
        }
    }

    Sort();
}

enum SortMethod {
    NameAsc,
    NameDesc,
    CodePointAsc,
    CodePointDesc
}

void Sort() {
    if (iconsFiltered.Length < 2) {
        return;
    }

    switch (sortMethod) {
        case SortMethod::NameAsc:
            iconsFiltered.Sort(function(a, b) {
                return a.name.ToLower() < b.name.ToLower();
            });
            break;

        case SortMethod::NameDesc:
            iconsFiltered.Sort(function(a, b) {
                return a.name.ToLower() > b.name.ToLower();
            });
            break;

        case SortMethod::CodePointAsc:
            iconsFiltered.Sort(function(a, b) {
                return a.codePoint < b.codePoint;
            });
            break;

        case SortMethod::CodePointDesc:
            iconsFiltered.Sort(function(a, b) {
                return a.codePoint > b.codePoint;
            });
            break;
    }
}

uint UTF8ToCodepoint(const uint8[]& bytes) {
    switch (bytes.Length) {
        case 1:
            return bytes[0];

        case 2:
            return 0x0
                | (bytes[0] & 0x1F) << 6
                | (bytes[1] & 0x3F)
            ;

        case 3:
            return 0x0
                | (bytes[0] & 0xF) << 12
                | (bytes[1] & 0x3F) << 6
                | (bytes[2] & 0x3F)
            ;

        case 4:
            return 0x0
                | (bytes[0] & 0x7) << 18
                | (bytes[1] & 0x3F) << 12
                | (bytes[2] & 0x3F) << 6
                | (bytes[3] & 0x3F)
            ;

        default:
            return 0x0;
    }
}
