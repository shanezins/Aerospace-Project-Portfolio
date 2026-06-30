\# 2D 3DOF Rocket Takeoff Simulation with Thrust Vector Control



\## Overview



This project models a simplified two-dimensional rocket takeoff using MATLAB and Simulink. The simulation includes horizontal motion, vertical motion, and pitch dynamics, with control inputs for thrust magnitude and thrust vectoring through a gimbal angle. The objective is to guide the rocket from rest to a commanded target position while reducing final position error and settling near the target with near-zero final velocity. The base demonstration case uses `x\_target = -50 m` and `z\_target = 150 m`.



\## Portfolio Context and Learning Objectives



This is the first project in my aerospace engineering portfolio, and I created it as both a way to learn and experiment with MATLAB and Simulink and as a way to build a base understanding of how to create an aerospace simulation project from start to finish. The goal was not to immediately create a fully high-fidelity rocket model, but to build a working simulation that connected dynamics, controls, trajectory tracking, thrust vectoring, plotting, animation, validation, and GitHub documentation. This project was very beneficial in terms of applying MATLAB and Simulink to something related to the aerospace industry, and it is intended to be a stepping stone toward both improving this model to make it closer to real life and creating brand new projects in the aerospace field.



\## Use of AI-Assisted Tools



AI-assisted tools, including MATLAB Copilot and ChatGPT, were used to help streamline parts of the plotting, animation, and documentation process. These tools were mainly used to help organize code, generate plots, confirm results, and improve the project writeup. Every major step of the modeling, control architecture, simulation setup, and result interpretation was reviewed and understood throughout the process, and the project can be explained from both an engineering and implementation perspective.



\## Project Goals



The main goals of this project were to develop a simplified 2D rocket dynamics model in Simulink, implement thrust and pitch control using feedback control, command the rocket to a desired position in the x-z plane, generate plots to evaluate the response, animate the rocket motion, and validate the controller across multiple target positions.



\## Model Description



The rocket is modeled as a simplified 3 degree-of-freedom system in the x-z plane. The main states are horizontal position `x`, vertical position `z`, and pitch angle `theta`, along with the corresponding velocities and pitch rate. The control inputs are thrust magnitude `T` and gimbal angle `delta`. The translational motion is modeled by resolving thrust into horizontal and vertical components, while the pitch motion is controlled by the moment generated from the thrust vector acting about the rocket center of gravity.



\## Control Architecture



The control system uses a cascaded structure. The altitude controller compares the commanded altitude to the current altitude and generates a thrust command, allowing the rocket to climb, descend, or settle near the desired altitude. The horizontal position controller compares the commanded horizontal position to the current horizontal position and generates a commanded pitch angle. The pitch controller then commands the gimbal angle needed to rotate the rocket toward that commanded pitch angle. Overall, thrust magnitude is mainly used for vertical motion, while thrust vectoring is used for pitch and horizontal motion.



\## Base Case Results



The base simulation case shows the rocket traveling from rest to the commanded target position and settling near the final point with very small remaining velocity.



(figures/trajectory.png)



Final estimated speed = 0.0087 m/s



\## Position Response



The position response shows the horizontal and vertical positions converging toward their commanded values.



(figures/position\_response.png)



\## Pitch Response



The pitch response shows how the rocket changes attitude during the maneuver as it tracks the commanded motion.



(figures/pitch\_response.png)



\## Control Inputs



The thrust command adjusts throughout the flight to control vertical motion and settle near the target altitude, while the gimbal command controls the thrust vector direction so the rocket can rotate and accelerate horizontally.



(figures/thrust\_command.png)



(figures/gimbal\_command.png)



\## Animation



A rocket animation was created from the simulation output to visualize the vehicle motion, pitch angle, trajectory, target point, final position, and live simulation data.



(media/rocket\_animation.mp4)



\## Multiple Target Validation



To verify that the controller was not limited to a single target point, additional target positions were tested using the same controller gains and model structure. These cases show that the controller can guide the rocket to multiple commanded target positions using the same control architecture.



(figures/multiple\_target\_validation.png)



The validation results are saved in:





docs/multiple\_target\_validation\_results.csv





\## Repository Structure





3\_DOF\_Rocket\_TVC\_Simulation/

├── model/

│   └── rocket\_3dof.slx

├── scripts/

│   ├── run\_simulation.m

│   ├── plot\_results.m

│   ├── animate\_rocket.m

│   └── run\_test\_cases.m

├── figures/

│   ├── trajectory.png

│   ├── position\_response.png

│   ├── pitch\_response.png

│   ├── thrust\_command.png

│   ├── gimbal\_command.png

│   └── multiple\_target\_validation.png

├── media/

│   └── rocket\_animation.mp4

├── docs/

│   └── multiple\_target\_validation\_results.csv

└── README.md





\## How to Run



Open MATLAB, navigate to the `scripts` folder, and run the scripts below depending on what part of the project you want to view.



run\_simulation

plot\_results

animate\_rocket

run\_test\_cases





\## Assumptions and Simplifications



This project uses a simplified rocket model with two-dimensional motion, constant mass, no aerodynamic drag, no wind disturbances, simplified pitch dynamics, ideal sensor feedback, simplified actuator behavior, and no fuel depletion model. These assumptions keep the project focused on flight dynamics, feedback control, simulation workflow, and visualization rather than full high-fidelity rocket modeling.



\## Tools Used



This project used MATLAB, Simulink, MATLAB plotting tools, MATLAB Copilot, ChatGPT, and GitHub for version control and documentation.



\## Future Improvements



Future improvements could include adding aerodynamic drag, changing mass due to fuel burn, actuator rate limits, sensor noise, a Kalman filter for state estimation, waypoint-based guidance logic, improved animation with gimbal and thrust vector visualization, and eventually expanding the model toward higher-fidelity 6DOF dynamics.



\## Summary



This project demonstrates a complete simulation workflow for a simplified thrust-vector-controlled rocket. The model includes dynamics, feedback control, trajectory tracking, control input visualization, animation, and validation across multiple target points. It serves as a first aerospace engineering portfolio project and provides a foundation for more advanced simulation, controls, and MATLAB/Simulink projects in the future.



