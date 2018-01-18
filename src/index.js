import './main.css';
import { Main } from './Main.elm';

const KEY_PREFIX = 'sokobanPlayer';
const KEY_LEVELS = KEY_PREFIX + 'Levels';
const KEY_DATA = KEY_PREFIX + 'Data';
const levels = localStorage.getItem(KEY_LEVELS);
const levelsData = localStorage.getItem(KEY_DATA);

const app = Main.embed(document.getElementById('root'), {
    levels,
    levelsData,
});

app.ports.portStoreLevels.subscribe(data => {
    localStorage.setItem(KEY_LEVELS, data);
});

app.ports.portStoreData.subscribe(data => {
    localStorage.setItem(KEY_DATA, data);
});
