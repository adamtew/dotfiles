#!/bin/bash
sleep 500
bin/blockscout eval "Elixir.Explorer.ReleaseTasks.create_and_migrate()"
bin/blockscout start