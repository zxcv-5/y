local TweenService = game:GetService("TweenService")
local th = {}
local notifications = {} -- Lưu trữ danh sách thông báo hiện tại

function th.New(message, duration)
    duration = duration or 3 -- Thời gian hiển thị mặc định là 3 giây

    -- Tạo ScreenGui nếu chưa tồn tại
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("NotificationGui") or Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.Parent = playerGui

    -- Tạo khung thông báo
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.35, 0, 0.08, 0) -- Kích thước khung thông báo
    frame.Position = UDim2.new(0.325, 0, 0.1 + (#notifications * 0.1), 0) -- Tự động căn chỉnh theo thứ tự
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Màu nền
    frame.BackgroundTransparency = 0.15 -- Độ trong suốt
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Bo góc mềm mại
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = frame

    -- Hiệu ứng gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 150))
    }
    gradient.Rotation = 45
    gradient.Parent = frame

    -- Tạo văn bản thông báo
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    textLabel.Parent = frame

    -- Thêm thông báo vào danh sách
    table.insert(notifications, frame)

    -- Xóa thông báo sau thời gian hiển thị với hiệu ứng
    task.delay(duration, function()
        -- Tween để chạy lên chậm hơn
        local goal = {Position = frame.Position - UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Size = UDim2.new(0.35, 0, 0.05, 0)}
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) -- Di chuyển chậm hơn
        local tween = TweenService:Create(frame, tweenInfo, goal)

        tween:Play()
        tween.Completed:Wait() -- Đợi tween hoàn thành
        frame:Destroy()

        -- Xóa khỏi danh sách
        table.remove(notifications, table.find(notifications, frame))

        -- Dịch chuyển các thông báo còn lại lên trên theo thứ tự
        for i, notif in ipairs(notifications) do
            local targetPosition = UDim2.new(0.325, 0, 0.1 + ((i - 1) * 0.1), 0)
            local moveTween = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition})
            task.delay((i - 1) * 0.1, function() -- Thêm khoảng trễ giữa các thông báo
                moveTween:Play()
            end)
        end
    end)
end
return th
