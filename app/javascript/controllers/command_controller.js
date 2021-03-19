import { Controller } from 'stimulus'
import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  spell_q () { this.stimulate('Users#spell_q') }
  spell_w () { this.stimulate('Users#spell_w') }
  spell_e () { this.stimulate('Users#spell_e') }
  spell_r () { this.stimulate('Users#spell_r') }
}
