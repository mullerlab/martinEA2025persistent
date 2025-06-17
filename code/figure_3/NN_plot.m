function H = NN_plot(numClusters, nodesPerCluster, inhibitoryGroupSize, clusterRadius, clusterSpread, inhibitorySpread)
%{
Fig 1: Neural Network Architecture Visualization
Call: NN_plot(12, 25, 100, 20, 3, 2);
Purpose:
This function visualizes the architecture of a neural network with distinct excitatory and inhibitory neuron groups. It uses a graph-based approach to represent the connectivity between neurons, with different aesthetic properties for clarity and differentiation.
Parameters:
- numClusters: Number of excitatory neuron clusters.
- nodesPerCluster: Number of neurons in each excitatory cluster.
- inhibitoryGroupSize: Number of inhibitory neurons in the central group.
- clusterRadius: Radius for positioning excitatory clusters.
- clusterSpread: Spread parameter for excitatory nodes.
- inhibitorySpread: Spread parameter for inhibitory nodes.
Aesthetic Considerations:
- Nodes are color-coded: red for inhibitory neurons and blue for excitatory neurons.
- Edges are color-coded based on the type of source neuron: red for edges emanating from inhibitory neurons and blue for those from excitatory neurons.
- The figure background is set to white for a clean and professional appearance.
- A legend is included to clarify the meaning of edge colors, enhancing the interpretability of the visualization.
%}
if nargin < 1
 numClusters = 12;
end
if nargin < 2
 nodesPerCluster = 25;
end
if nargin < 3
 inhibitoryGroupSize = 125;
end
if nargin < 4
 clusterRadius = 30;
end
if nargin < 5
 clusterSpread = 2.5;
end
if nargin < 6
 inhibitorySpread = 2;
end
 totalNodes = numClusters * nodesPerCluster + inhibitoryGroupSize;
% Connection probabilities
 intraClusterConnRatio = 0.3;
 interClusterConnRatio = 0.5;
 inhibConnRatio = 0.6;
 excitInhibConnRatio = 0.4;

% Initialize graph
 G = digraph();

% Node positions
 positions = zeros(totalNodes, 2);

% Randomize inhibitory group positions
 positions(1:inhibitoryGroupSize, 1) = inhibitorySpread * randn(inhibitoryGroupSize, 1);
 positions(1:inhibitoryGroupSize, 2) = inhibitorySpread * randn(inhibitoryGroupSize, 1);

% Parameters for the ellipse in each cluster
 a = 1.0 * clusterSpread; % Horizontal spread of the cluster
 b = 2 * clusterSpread; % Vertical spread of the cluster

% Position excitatory nodes with elliptical clusters
for c = 1:numClusters
 angle = 2*pi * (c-1) / numClusters;    % Cluster center angle
 clusterCenter = clusterRadius * [cos(angle), sin(angle)];

 % Generate polar coordinates within an ellipse
 theta = 2*pi * rand(nodesPerCluster, 1);  % Uniform random angles

 % Distance from center varies inversely with distance from cluster center for more jitter near the center
 r = (rand(nodesPerCluster, 1)).^0.5;  % Square root to concentrate more points near the center

 % Elliptical coordinates
 xOffsets = a * r .* cos(theta);
 yOffsets = b * r .* sin(theta);

 % Rotate ellipse to align with circle circumference
 rotationMatrix = [cos(angle), -sin(angle); sin(angle), cos(angle)];
 rotatedOffsets = [xOffsets, yOffsets] * rotationMatrix';

 % Positions are cluster center plus offsets
 scatterX = clusterCenter(1) + rotatedOffsets(:,1);
 scatterY = clusterCenter(2) + rotatedOffsets(:,2);
 idx = inhibitoryGroupSize + (1:nodesPerCluster) + (c-1)*nodesPerCluster;
 positions(idx, 1) = scatterX;
 positions(idx, 2) = scatterY;

 % Build intra-cluster connections as before
 for i = 1:nodesPerCluster
   for j = i+1:nodesPerCluster
     if rand() < intraClusterConnRatio
      G = addedge(G, idx(i), idx(j));
     end
   end
 end
end
% Inter-cluster connections
for i = 1:round(interClusterConnRatio * numClusters * nodesPerCluster)
 cluster1 = randi(numClusters);
 cluster2 = randi(numClusters);
 while cluster1 == cluster2
  cluster2 = randi(numClusters);
 end
 node1 = randi(nodesPerCluster) + inhibitoryGroupSize + (cluster1-1)*nodesPerCluster;
 node2 = randi(nodesPerCluster) + inhibitoryGroupSize + (cluster2-1)*nodesPerCluster;
 if rand() < interClusterConnRatio
  G = addedge(G, node1, node2);
 end
end

% Inhibitory to excitatory connections
for i = 1:round(inhibConnRatio * numClusters * nodesPerCluster)
 excitatoryNode = randi([inhibitoryGroupSize+1, totalNodes]);
 inhibitoryNode = randi([1, inhibitoryGroupSize]);
 if rand() < inhibConnRatio
  G = addedge(G, inhibitoryNode, excitatoryNode);
 end
end

% Excitatory to inhibitory connections
for i = 1:round(excitInhibConnRatio * numClusters * nodesPerCluster)
 excitatoryNode = randi([inhibitoryGroupSize+1, totalNodes]);
 inhibitoryNode = randi([1, inhibitoryGroupSize]);
 if rand() < excitInhibConnRatio
  G = addedge(G, excitatoryNode, inhibitoryNode);
 end
end

% Plot the graph
figure('Position', get(0, 'ScreenSize'))
 H = plot(G, 'XData', positions(:,1), 'YData', positions(:,2), ...
'MarkerSize', 4, 'EdgeAlpha', 0.4, 'ArrowSize', 0);

% Set node colors based on neuron type
 highlight(H, inhibitoryGroupSize+1:totalNodes, 'NodeColor', [220 41 45]/255); % Excitatory nodes
 highlight(H, 1:inhibitoryGroupSize, 'NodeColor', [37 170 225]/255); % Inhibitory nodes


% Set edge colors based on source node type
for e = 1:numedges(G)
 src = G.Edges.EndNodes(e, 1);
 target = G.Edges.EndNodes(e, 2);
 if src <= inhibitoryGroupSize
  highlight(H, 'Edges', e, 'EdgeColor', [37 170 225]/255, LineWidth=1); % Inhibitory edges
 elseif src >= inhibitoryGroupSize & target<= inhibitoryGroupSize
  highlight(H, 'Edges', e, 'EdgeColor', [220 41 45]/255, LineWidth=1.2); % Excitatory edges
 else
     highlight(H, 'Edges', e, 'EdgeColor', [220 41 45]/255, LineWidth=0.5); % Excitatory edges
 end
end

% Create dummy plot handles for legend
 hold on;
 h1 = plot(nan, nan, 'Color', [37 170 225]/255, 'LineWidth', 1.5);
 h2 = plot(nan, nan, 'Color', [220 41 45]/255, 'LineWidth', 1.5);
 legend([h1, h2], {'Inhibitory Edges', 'Excitatory Edges'}, 'Location', 'bestoutside');
 legend boxoff
 hold off;
% Set axis properties
 set(gca, 'Color', 'w');
 axis equal;
 axis off;
end

