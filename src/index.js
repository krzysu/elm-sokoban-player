import "../node_modules/noty/lib/noty.css";
import "../node_modules/noty/lib/themes/relax.css";
import './css/main.css';
import './css/ui.css';
import './css/game.css';
import './css/pages.css';
import { Main } from './Main.elm';
import registerServiceWorker from './js/registerServiceWorker';
import isTouchDevice from './js/isTouchDevice';
import { getLevels, storeLevels, getLevelsData, storeLevelsData} from './js/storage';

// init elm app
const app = Main.embed(document.getElementById('root'), {
    levels: getLevels(),
    levelsData: getLevelsData(),
});

// subscribe to ports
app.ports.portStoreLevels.subscribe(data => {
    storeLevels(data);
});

app.ports.portStoreData.subscribe(data => {
    storeLevelsData(data);
});

app.ports.portScrollToTop.subscribe(() => {
    document.getElementById('root').scrollIntoView();
});

app.ports.portAnalytics.subscribe(pageUrl => {
    if (ga && typeof ga === 'function') {
        ga('set', 'page', pageUrl);
        ga('send', 'pageview');
    }
});

// service worker
registerServiceWorker();

// extra classes
if (isTouchDevice()) {
    document.body.classList.add('is-touch');
}
