import ActionCable from 'actioncable';

var cable = ActionCable.createConsumer("ws://localhost:3000/cable");

export { cable }