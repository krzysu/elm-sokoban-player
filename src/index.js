import './main.css';
import { Main } from './Main.elm';

const KEY_LEVELS = 'sokobanPlayerLevels';
const levels = localStorage.getItem(KEY_LEVELS);

const app = Main.embed(document.getElementById('root'), {
    levels,
});

app.ports.portStoreLevels.subscribe(objectToStore => {
    localStorage.setItem(KEY_LEVELS, objectToStore);
});
