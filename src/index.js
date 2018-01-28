import './css/main.css';
import './css/game.css';
import { Main } from './Main.elm';
import registerServiceWorker from './js/registerServiceWorker';
import isTouchDevice from './js/isTouchDevice';
import { getLevels, storeLevels, getLevelsData, storeLevelsData} from './js/storage';

// init elm app
const app = Main.embed(document.getElementById('root'), {
    levels: getLevels(),
    levelsData: getLevelsData(),
    isTouchDevice: isTouchDevice(),
});

// subscribe to ports
app.ports.portStoreLevels.subscribe(data => {
    storeLevels(data);
});

app.ports.portStoreData.subscribe(data => {
    storeLevelsData(data);
});

// service worker
registerServiceWorker();

// extra classes
if (isTouchDevice()) {
    document.body.classList.add('is-touch');
}
