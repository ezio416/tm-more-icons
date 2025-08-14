// c 2025-08-13
// m 2025-08-13

funcdef int SortFunc(Icon@ m1, Icon@ m2);

enum SortMethod {
    NameAsc,
    NameDesc,
    CodePointAsc,
    CodePointDesc
}

const SortFunc@[] SortFuncs = {
    SortNameAsc,
    SortNameDesc,
    SortCodePointAsc,
    SortCodePointDesc
};

Icon@[]@ QuickSortAsync(Icon@[]@ arr, SortFunc@ func, int left = 0, int right = -1) {
    const uint64 now = Time::Now;
    if (now - sortLastYield > maxFrameTime) {
        sortLastYield = now;
        yield();
    }

    if (right < 0) {
        right = arr.Length - 1;
    }

    if (arr.Length == 0) {
        return arr;
    }

    int i = left;
    int j = right;
    Icon@ pivot = arr[(left + right) / 2];

    while (i <= j) {
        while (func(arr[i], pivot) < 0) {
            i++;
        }

        while (func(arr[j], pivot) > 0) {
            j--;
        }

        if (i <= j) {
            Icon@ temp = arr[i];
            @arr[i] = arr[j];
            @arr[j] = temp;
            i++;
            j--;
        }
    }

    if (left < j) {
        arr = QuickSortAsync(arr, func, left, j);
    }

    if (i < right) {
        arr = QuickSortAsync(arr, func, i, right);
    }

    return arr;
}

void Sort() {
    startnew(SortAsync);
}

void SortAsync() {
    if (iconsFiltered.Length < 2) {
        return;
    }

    iconsFiltered = QuickSortAsync(iconsFiltered, SortFuncs[sortMethod]);
}

int SortNameAsc(Icon@ a, Icon@ b) {
    const string n1 = a.name.ToLower();
    const string n2 = b.name.ToLower();

    if (n1 < n2) {
        return -1;
    }
    if (n1 > n2) {
        return 1;
    }
    return 0;
}

int SortNameDesc(Icon@ a, Icon@ b) {
    const string n1 = a.name.ToLower();
    const string n2 = b.name.ToLower();

    if (n1 < n2) {
        return 1;
    }
    if (n1 > n2) {
        return -1;
    }
    return 0;
}

int SortCodePointAsc(Icon@ a, Icon@ b) {
    return Math::Clamp(int(a.codePoint) - b.codePoint, -1, 1);
}

int SortCodePointDesc(Icon@ a, Icon@ b) {
    return Math::Clamp(int(b.codePoint) - a.codePoint, -1, 1);
}
