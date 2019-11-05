# complex-block-kit-modification
Modifying large block-kit messages in Elixir isn't easy. 

This demo suggests a pattern using a list of `block_id`s as a blueprint for the final message as well as a map from `block_id`s to anonymous functions in order to modify the blocks while maintaining flexibility.
