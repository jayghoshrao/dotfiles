#!/usr/bin/env python3

from rofi import Rofi
import pulsectl

SINK_ALIASES = {
  'Family 17h (Models 00h-0fh) HD Audio Controller Analog Stereo': "Builtin Analog Stereo",
  'PCM2912A Audio Codec Analog Stereo': "PCM2912A Audio Codec Analog Stereo",
}

def main():
    pulse = pulsectl.Pulse()
    rofi = Rofi()

    sinks = pulse.sink_list()
    current_default_name = pulse.server_info().default_sink_name
    current_default = None

    for i, s in enumerate(sinks):
        if s.name == current_default_name:
            current_default = i

    if current_default == None:
        print("Couldn't find the default sink?")
        return

    sink_index, _ = rofi.select("Select default sink", [s.description if s.description not in SINK_ALIASES else SINK_ALIASES[s.description] for s in sinks], select=current_default, rofi_args=['-i', '-matching fuzzy'])

    if sink_index == -1:
        return

    pulse.default_set(sinks[sink_index])

    # move ALL sink inputs to default/selection
    sink_inputs = pulse.sink_input_list()
    # sink_input_index = -1 #Move all sink inputs
    for si in sink_inputs:
        pulse.sink_input_move(si.index, sinks[sink_index].index)


if __name__ == '__main__':
    main()
