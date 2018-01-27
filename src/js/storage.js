const KEY_PREFIX = 'sokobanPlayer';
const KEY_LEVELS = KEY_PREFIX + 'Levels';
const KEY_DATA = KEY_PREFIX + 'Data';

export const getLevels = () => {
    return localStorage.getItem(KEY_LEVELS);
}

export const getLevelsData = () => {
    return localStorage.getItem(KEY_DATA);
}

export const storeLevels = (data) => {
    localStorage.setItem(KEY_LEVELS, data);
}

export const storeLevelsData = (data) => {
    localStorage.setItem(KEY_DATA, data);
}
