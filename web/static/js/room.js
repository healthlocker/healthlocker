let Room = {
  init(socket, element) {
    if (!element) { return }

    let roomId = element.getAttribute("data-room-id")
    socket.connect()

    this.onReady(roomId, socket)
  },

  onReady(roomId, socket) {
    let msgContainer  = document.getElementById("messages")
    let msgInput      = document.getElementById("message-input")
    let roomChannel   = socket.channel("room:" + roomId)

    msgInput.addEventListener("keypress", e => {
      if (e.keyCode == 13) {
        let payload = {
          body: msgInput.value
        }
        roomChannel.push("new:msg", payload, 10000)
          .receive("error", e => console.log(e))
        msgInput.value = ""
      }
    })

    roomChannel.on("msg:created", (resp) => {
      console.log("Hello, world!!!");
      this.renderMessage(msgContainer, resp)
    })

    roomChannel.join()
      .receive("ok", resp => console.log("joined the room channel", resp) )
      .receive("error", reason => console.log("join failed", reason) )
  },

  renderMessage(msgContainer, {user, body}) {
    let template = document.createElement("div")
    template.innerHTML = `
      <p class="text-wrap">
        <b>${user.name}:</b> ${body}
      </p>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  }
}

export default Room
