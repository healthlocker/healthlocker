var Chat = {
  init (socket) {
    var input = document.getElementById('message-input')
    var msgContainer = document.getElementById('messages')
    socket.onOpen(e => console.log('Open', e))
    socket.onError(e => console.log('Error', e))
    socket.onClose(e => console.log('Close', e))

    var channel = socket.channel('room:general')
    channel.join()
      .receive('error', reason => console.log('Error: ', reason))
      .receive('timeout', () => console.log('Connection Timeout'))
      .receive('ok', ({messages}) => {
        messages.forEach(msg => renderMessages(msgContainer, msg))
      })

    channel.onError(e => console.log('Something went wrong'))
    channel.onClose(e => console.log('Channel closed'))

    input.addEventListener('keypress', e => {
      if (e.keyCode === 13) {
        channel.push('new:msg', {body: input.value}, 10000)
        input.value = ''
      }
    }, false)

    channel.on('new:msg', msg => {
      renderMessages(msgContainer, msg)
    })

    function renderMessages (container, msg) {
      container.innerHTML = `<p class="text-wrap">${msg.name}&nbsp; ${msg.body}</p>` + container.innerHTML
    }
  }
}

export default Chat
