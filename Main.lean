import MicroserviceUpdates.Examples.MultiplierAdapter

open MicroserviceUpdates.Examples.MultiplierAdapter

def main : IO Unit := do
  IO.println s!"candidate repetition count: {synthesizeMultiplier}"
  IO.println s!"adapter(7): {certifiedAdapter.translate 7}"
  IO.println s!"old batch from state 3: {oldService.runAtomically 3 (certifiedAdapter.translate 7)}"
  IO.println s!"new direct from state 3: {newService.step 3 7}"

