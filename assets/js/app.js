import UIkit from 'uikit'
import Icons from 'uikit/dist/js/uikit-icons'

import 'phoenix_html'
import { Socket } from 'phoenix'
import LiveSocket from 'phoenix_live_view'

import css from '../css/app.css'

let liveSocket = new LiveSocket('/live', Socket)
liveSocket.connect()

UIkit.use(Icons)

window.UIkit = UIkit
