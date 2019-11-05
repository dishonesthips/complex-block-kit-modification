defmodule Project.Utils do
  # like Kernel.put_in but it can add a k/v pair to an existing nested map rather than only update the value
  def put_kv_in(map, [], new_key, new_value), do: Map.put(map, new_key, new_value)

  def put_kv_in(map, [head | tail], new_key, new_value) do
    Map.put(map, head, put_kv_in(map[head], tail, new_key, new_value))
  end
end

defmodule Project.Demo do
  # acts as a blueprint for the block-kit message you plan to build
  # supports blocks that need to be updated as well as ones that don't require any modifications
  # (which appear in all caps with an underscore at the beginning to differentiate)
  @update_blocks ["title_block", "_DIVIDER", "priority_block", "time_block"]

  # lay out the blocks you need as attributes
  # not necessary as they can be hard coded into the map function
  # but this is better practice since it allows them to be used elsewhere
  @title_block %{
    type: "input",
    element: %{
      type: "plain_text_input",
      action_id: "title_value",
      placeholder: %{
        type: "plain_text",
        text: "Enter a Title"
      },
      initial_value: " "
    },
    label: %{
      type: "plain_text",
      text: "Issue Title"
    },
    block_id: "title_block"
  }
  @priority_block %{
    type: "input",
    element: %{
      type: "static_select",
      action_id: "priority_value",
      placeholder: %{
        type: "plain_text",
        text: "Select a Priority",
        emoji: true
      },
      options: [
        %{
          text: %{
            type: "plain_text",
            text: "P1",
            emoji: true
          },
          value: "p1_value"
        },
        %{
          text: %{
            type: "plain_text",
            text: "P2",
            emoji: true
          },
          value: "p2_value"
        },
        %{
          text: %{
            type: "plain_text",
            text: "P3",
            emoji: true
          },
          value: "p3_value"
        }
      ]
    },
    label: %{
      type: "plain_text",
      text: "Priority of Issue",
      emoji: true
    },
    block_id: "priority_block"
  }
  @time_block %{
    type: "input",
    element: %{
      type: "plain_text_input",
      action_id: "time_value",
      placeholder: %{
        type: "plain_text",
        text: "ex: 9:33 AM EST"
      }
    },
    label: %{
      type: "plain_text",
      text: "Time of Issue"
    },
    block_id: "time_block"
  }
  @_DIVIDER %{
    type: "divider"
  }

  # a mapping from block_id to anonymous functions that modify the blocks
  def update_map() do
    %{
      "title_block" => fn data ->
        @title_block
        |> Project.Utils.put_kv_in(
          [:element],
          :initial_value,
          data["title_value"]
        )
      end,
      "priority_block" => fn data ->
        @priority_block
        |> Project.Utils.put_kv_in(
          [:element],
          :initial_option,
          data["priority_value"]
        )
      end,
      "time_block" => fn data ->
        @time_block
        |> Project.Utils.put_kv_in(
          [:element],
          :initial_value,
          data["time_value"]
        )
      end,
      "_DIVIDER" => fn _ -> @_DIVIDER end
    }
  end

  def run_demo(), do: fake_data() |> build_message()

  def fake_data() do
    %{
      "priority_data" => "priority_value",
      "time_data" => "time_value",
      "title_data" => "title_value"
    }
  end

  # runs through the blueprint, modifying the blocks one by one
  # outputs completed block-kit message
  def build_message(data) do
    update_map = update_map()
    blueprint = @update_blocks

    for block_id <- blueprint, do: update_map[block_id].(data)
  end
end
