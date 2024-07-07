% 清除工作区和命令窗口
clear;
clc;

% 定义问题的维数
n = 9;

% 决策变量 x_ijk 的数量
num_vars = n^3;

% 定义目标函数
f = ones(num_vars, 1); % 目标函数在这个问题中不重要，因为我们只需要满足约束条件

% 定义等式约束矩阵 Aeq 和右侧向量 beq
Aeq = [];
beq = [];

% 约束1: 每行的每个数字恰好出现一次
for k = 1:n
    for i = 1:n
        row = zeros(1, num_vars);
        for j = 1:n
            row((k-1)*n^2 + (i-1)*n + j) = 1;
        end
        Aeq = [Aeq; row];
        beq = [beq; 1];
    end
end

% 约束2: 每列的每个数字恰好出现一次
for k = 1:n
    for j = 1:n
        row = zeros(1, num_vars);
        for i = 1:n
            row((k-1)*n^2 + (i-1)*n + j) = 1;
        end
        Aeq = [Aeq; row];
        beq = [beq; 1];
    end
end

% 约束3: 每个小方块内每个数字恰好出现一次
for k = 1:n
    for block_row = 0:2
        for block_col = 0:2
            row = zeros(1, num_vars);
            for i = 1:3
                for j = 1:3
                    row((k-1)*n^2 + (block_row*3+i-1)*n + (block_col*3+j)) = 1;
                end
            end
            Aeq = [Aeq; row];
            beq = [beq; 1];
        end
    end
end

% 约束4: 数字1-9恰好在每个格子中出现一次
for i = 1:n
    for j = 1:n
        row = zeros(1, num_vars);
        for k = 1:n
            row((k-1)*n^2 + (i-1)*n + j) = 1;
        end
        Aeq = [Aeq; row];
        beq = [beq; 1];
    end
end

% 初始条件: 已知的数独格子中的数字
sudoku_initial = [
    5 3 0 0 7 0 0 0 0;
    6 0 0 1 9 5 0 0 0;
    0 9 8 0 0 0 0 6 0;
    8 0 0 0 6 0 0 0 3;
    4 0 0 8 0 3 0 0 1;
    7 0 0 0 2 0 0 0 6;
    0 6 0 0 0 0 2 8 0;
    0 0 0 4 1 9 0 0 5;
    0 0 0 0 8 0 0 7 9
];

for i = 1:n
    for j = 1:n
        if sudoku_initial(i,j) ~= 0
            k = sudoku_initial(i,j);
            row = zeros(1, num_vars);
            row((k-1)*n^2 + (i-1)*n + j) = 1;
            Aeq = [Aeq; row];
            beq = [beq; 1];
        end
    end
end

% 定义变量的上下界 (0 <= x_ijk <= 1)
lb = zeros(num_vars, 1);
ub = ones(num_vars, 1);

% 定义变量类型为整数
intcon = 1:num_vars;

% 求解整数线性规划
options = optimoptions('intlinprog', 'Display', 'off');
[x, fval, exitflag] = intlinprog(f, intcon, [], [], Aeq, beq, lb, ub, options);

% 检查是否找到最优解
if exitflag == 1
    disp('找到最优解:');
    solution = reshape(x, [n, n, n]);
    solved_sudoku = zeros(n, n);
    for i = 1:n
        for j = 1:n
            for k = 1:n
                if solution(i, j, k) > 0.99
                    solved_sudoku(i, j) = k;
                end
            end
        end
    end
    disp(solved_sudoku);
else
    disp('未找到最优解');
end
