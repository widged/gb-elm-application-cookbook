# Sending messages to sibling components in Elm Architecture

This app demonstrate a pattern on how to send message from one component to a sibling component

Component `Trigger` want to send a message to `Messages`.

How is this working at the moment:

In Trigger:

- Clicking on the trigger button send a `ShowMessage` action.
- `update` on Trigger picks this action and return a tuple with three values, which is not the normal start app two value convention.
- The last value of this tuple is an effect tagged with a `MainAction.ShowMessage` action.

In Main

- `update` in the Main module receives the `MainAction.ShowMessage` action.
- This returns a effect tagged with `MessagesActions.ShowMessage` action.
- `update` then receives `MessagesActions` and sends this to the Messages module.

In Messages

- `update` receives the `MessagesActions.ShowMessage` action and updates the model to show the message.

Problems:

- The action `ShowMessage` is in three places: Trigger, Main and Messages
- This is very convoluted

__How can this be done nicer?__