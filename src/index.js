import './css/main.css';
import './css/game.css';
import { Main } from './Main.elm';
import isTouchDevice from './js/isTouchDevice';
import { getLevels, storeLevels, getLevelsData, storeLevelsData} from './js/storage';

const app = Main.embed(document.getElementById('root'), {
    levels: getLevels(),
    levelsData: getLevelsData(),
    isTouchDevice: isTouchDevice(),
});

app.ports.portStoreLevels.subscribe(data => {
    storeLevels(data);
});

app.ports.portStoreData.subscribe(data => {
    storeLevelsData(data);
});


if (isTouchDevice()) {
    document.body.classList.add('is-touch');
}
