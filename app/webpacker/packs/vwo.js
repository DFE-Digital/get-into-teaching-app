import Vwo from '../javascript/vwo'

const vwoId = document.querySelector("[data-vwo-id]").dataset.vwoId

if (vwoId) {
  const vwo = new Vwo(vwoId)
  vwo.init()
}
