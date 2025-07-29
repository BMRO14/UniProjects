import numpy as np
import sounddevice as sd
import soundfile as sf

# Parameters
sample_rate = 44100  # Sample rate in Hz
duration = 5  # Duration of recording in seconds

# Record audio from the microphone
def record_audio(duration, sample_rate):
    print("Sampling...")
    audio = sd.rec(int(duration * sample_rate), samplerate=sample_rate, channels=1, dtype='float64')
    sd.wait()
    print("Recording complete.")
    return audio.flatten()

# Echo effect
def apply_echo(audio, delay, decay, sample_rate):
    delay_samples = int(delay * sample_rate)
    echo_signal = np.zeros(len(audio) + delay_samples)
    echo_signal[:len(audio)] = audio
    echo_signal[delay_samples:] += decay * audio
    return echo_signal

# Chorus effect
def apply_chorus(audio, sample_rate, depth=0.002, rate=1.5, mix=0.5):
    t = np.arange(len(audio)) / sample_rate
    lfo = np.sin(2 * np.pi * rate * t)  # Low-frequency oscillator for modulation

    chorus_signal = np.zeros_like(audio)
    delay_samples_range = int(depth * sample_rate)  # Calculate delay in samples

    for i in range(len(audio)):
        delay_samples = int((1 + lfo[i]) * delay_samples_range)
        if i - delay_samples >= 0:
            chorus_signal[i] = audio[i - delay_samples]

    processed_audio = (1 - mix) * audio + mix * chorus_signal
    return processed_audio

# Flanger effect
def apply_flanger(audio, sample_rate, depth=0.002, rate=0.25, delay=0.005, feedback=0.5, mix=0.5):
    t = np.arange(len(audio)) / sample_rate
    lfo = depth * np.sin(2 * np.pi * rate * t)  # Low-frequency oscillator for modulation
    
    modulated_delay = (delay + lfo) * sample_rate
    flanger_signal = np.zeros_like(audio)

    for i in range(len(audio)):
        delay_samples = int(modulated_delay[i])
        if i - delay_samples >= 0:
            flanger_signal[i] = audio[i - delay_samples] + feedback * flanger_signal[i - delay_samples]
    
    processed_audio = (1 - mix) * audio + mix * flanger_signal
    return processed_audio

# Distortion effect
def apply_distortion(audio, gain=30.0, threshold=0.05):
    # Apply gain
    amplified_signal = gain * audio

    # Hyperbolic tangent function for non-linear distortion
    distorted_signal = np.tanh(amplified_signal)

    # Optional: Normalize the signal to ensure the output stays within [-1, 1]
    max_val = np.max(np.abs(distorted_signal))
    if max_val > 0:
        distorted_signal = distorted_signal / max_val

    return distorted_signal

# Main function to process the audio
def process_audio(effect_type):
    audio = record_audio(duration, sample_rate)

    if effect_type == 'echo':
        delay = 0.5  # 500 ms delay
        decay = 0.5  # 50% decay
        processed_audio = apply_echo(audio, delay, decay, sample_rate)
    elif effect_type == 'chorus':
        processed_audio = apply_chorus(audio, sample_rate)
    elif effect_type == 'flanger':
        processed_audio = apply_flanger(audio, sample_rate)
    elif effect_type == 'distortion':
        processed_audio = apply_distortion(audio)
    else:
        raise ValueError("Unsupported effect type")

    # Save the processed audio to a file
    output_file = f"processed_{effect_type}.wav"
    sf.write(output_file, processed_audio, sample_rate)
    print(f"Processed audio saved to {output_file}")

    # Playback the processed audio
    sd.play(processed_audio, sample_rate)
    sd.wait()
    print("Playback complete.")

# Example usage
if __name__ == "__main__":
    effect_type = input("Enter the effect you want to apply (echo, chorus, flanger, distortion): ").strip().lower()
    process_audio(effect_type)
