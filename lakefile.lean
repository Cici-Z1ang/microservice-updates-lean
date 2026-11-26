import Lake
open Lake DSL

package "microservice-updates" where
  version := v!"0.1.0"

@[default_target]
lean_lib MicroserviceUpdates where

@[default_target]
lean_exe adapterDemo where
  root := `Main

