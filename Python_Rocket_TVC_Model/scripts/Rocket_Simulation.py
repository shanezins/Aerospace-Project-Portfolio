import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
from pathlib import Path

# Project Paths
project_dir = Path(__file__).resolve().parents[1]
figures_dir = project_dir / "figures"
figures_dir.mkdir(exist_ok=True)

# Target Position
x_target = -50.0  # meters
z_target = 150.0 # meters

# Rocket Parameters
m = 100.0 # kg
Iyy= 500.0
g = 9.81 # m/s^2
lever_arm = 2.0 # meters

# Simulation Settings
t_final = 60.0 # seconds
num_points = 1000

t_eval = np.linspace(0.0, t_final, num_points)

# Controller Gains
Kz = 0.08
Kvz = 0.5

Kx = 0.002
Kvx = 0.025

Ktheta = 0.0969755
Kq = 0.35

# Control Limits
T_min = 0.0 # N
T_max = 4000.0 # N
theta_cmd_max = 0.35 # radians
delta_max = 0.2 # radians

# Helper function
def saturate(value, lower, upper):
    """Limit a value between a lower and upper bound."""
    return np.clip(value, lower, upper)

# Controller Function

def controller(x, z, vx, vz, theta, q):
    """Compute rocket control commands."""

    # Altitude Controller
    z_error = z_target - z
    az_cmd = Kz * z_error - Kvz * vz

    T_cmd = m * (g + az_cmd)
    T_cmd = saturate(T_cmd, T_min, T_max)

    # Horizontal position controller
    x_error = x_target - x
    theta_cmd = Kx * x_error - Kvx * vx
    theta_cmd = saturate(theta_cmd, -theta_cmd_max, theta_cmd_max)
    # Pitch / gimbal controller
    theta_error = theta_cmd - theta
    delta = Ktheta * theta_error - Kq * q
    delta = saturate(delta, -delta_max, delta_max)

    return T_cmd, theta_cmd, delta

# Rocket Dynamics Function
def rocket_dynamics(t, state):
    """Compute the derivatives of the rocket state."""
    x, z, vx, vz, theta, q = state

    T_cmd, theta_cmd, delta = controller(x, z, vx, vz, theta, q)

    # Translational dynamics
    ax = (T_cmd / m) * np.sin(theta + delta)
    az = (T_cmd / m) * np.cos(theta + delta) - g
    
    # Pitch dynamics
    q_dot = (T_cmd * lever_arm/Iyy) * np.sin(delta)

    return [vx, vz, ax, az, q, q_dot]

# Initial Conditions

x0 = 0.0
z0 = 0.0
vx0 = 0.0
vz0 = 0.0
theta0 = 0.0
q0 = 0.0

initial_state = [x0, z0, vx0, vz0, theta0, q0]

# Run Simulation

solution = solve_ivp(
    rocket_dynamics, 
    [0.0, t_final],
    initial_state,
    t_eval=t_eval
)

# Extract Results

t = solution.t

x = solution.y[0]
z = solution.y[1]
vx = solution.y[2]
vz = solution.y[3]
theta = solution.y[4]
q = solution.y[5]

# Recompute controller outputs for plotting

T_cmd_history = np.zeros_like(t)
theta_cmd_history = np.zeros_like(t)
delta_history = np.zeros_like(t)

for i in range(len(t)):
    T_cmd_history[i], theta_cmd_history[i], delta_history[i] = controller(
        x[i],
        z[i],
        vx[i],
        vz[i],
        theta[i],
        q[i]
    )

# Final Results

x_final = x[-1]
z_final = z[-1]

x_error = x_target - x_final
z_error = z_target - z_final

total_error = np.sqrt(x_error**2 + z_error**2)
final_speed = np.sqrt(vx[-1]**2 + vz[-1]**2)

print("Simulation complete.")
print(f"Final x position: {x_final:.3f} m")
print(f"Final z position: {z_final:.3f} m")
print(f"x error: {x_error:.3f} m")
print(f"z error: {z_error:.3f} m")
print(f"Total position error: {total_error:.3f} m")
print(f"Final speed: {final_speed:.6f} m/s")

# Plot altitude response

plt.figure()

plt.plot(t, z, linewidth=2, label="z position")
plt.axhline(z_target, linestyle="--", label="z target")

plt.xlabel("Time (s)")
plt.ylabel("Altitude z (m)")
plt.title("Altitude Response")
plt.grid(True)
plt.legend()

plt.savefig(figures_dir / "altitude_response.png", dpi=300, bbox_inches="tight")

plt.show()

# Plot x-z trajectory

plt.figure()

plt.plot(x, z, linewidth=2, label="Trajectory")
plt.plot(x[0], z[0], "o", markersize=8, label="Start")
plt.plot(x_target, z_target, "x", markersize=10, label="Target")
plt.plot(x_final, z_final, "s", markersize=7, label="Final position")

plt.xlabel("Horizontal Position x (m)")
plt.ylabel("Altitude z (m)")
plt.title("2D Rocket Trajectory")
plt.grid(True)
plt.axis("equal")
plt.legend()

plt.savefig(figures_dir / "trajectory.png", dpi=300, bbox_inches="tight")
plt.show()

# Plot position response

plt.figure()

plt.plot(t, x, linewidth=2, label="x position")
plt.plot(t, z, linewidth=2, label="z position")

plt.axhline(x_target, linestyle="--", label="x target")
plt.axhline(z_target, linestyle="--", label="z target")

plt.xlabel("Time (s)")
plt.ylabel("Position (m)")
plt.title("Position Response")
plt.grid(True)
plt.legend()

plt.savefig(figures_dir / "position_response.png", dpi=300, bbox_inches="tight")

plt.show()

# Plot pitch response

plt.figure()

plt.plot(t, np.rad2deg(theta), linewidth=2, label="theta")
plt.plot(t, np.rad2deg(theta_cmd_history), linestyle="--", linewidth=2, label="theta command")

plt.xlabel("Time (s)")
plt.ylabel("Pitch Angle (deg)")
plt.title("Pitch Response")
plt.grid(True)
plt.legend()

plt.savefig(figures_dir / "pitch_response.png", dpi=300, bbox_inches="tight")

plt.show()

# Plot thrust command

plt.figure()

plt.plot(t, T_cmd_history, linewidth=2, label="Thrust command")

plt.xlabel("Time (s)")
plt.ylabel("Thrust (N)")
plt.title("Thrust Command")
plt.grid(True)
plt.legend()

plt.savefig(figures_dir / "thrust_command.png", dpi=300, bbox_inches="tight")

plt.show()

# Plot gimbal command

plt.figure()

plt.plot(t, np.rad2deg(delta_history), linewidth=2, label="Gimbal angle")

plt.xlabel("Time (s)")
plt.ylabel("Gimbal Angle (deg)")
plt.title("Gimbal Command")
plt.grid(True)
plt.legend()

plt.savefig(figures_dir / "gimbal_command.png", dpi=300, bbox_inches="tight")

plt.show()