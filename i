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
    frame.Size = UDim2.new(0.35, 0, 0.08, 0) -- Cân đối với khung hình
    frame.Position = UDim2.new(0.325, 0, 0.1 + (#notifications * 0.1), 0) -- Tự động xuống dòng
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Màu nền xám đen
    frame.BackgroundTransparency = 0.15 -- Độ trong suốt nhẹ
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Thêm bóng đổ sắc nét
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- Bóng đổ
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = frame

    -- Bo góc mềm mại hơn
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20) -- Bo góc 20 pixel
    corner.Parent = frame

    -- Hiệu ứng gradient đẹp mắt
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 120, 255)), -- Xanh dương
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 150))  -- Xanh lá
    }
    gradient.Rotation = 45
    gradient.Parent = frame

    -- Tạo văn bản thông báo
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20) -- Cách lề một chút
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Văn bản màu trắng
    textLabel.Font = Enum.Font.GothamBold -- Phông chữ hiện đại
    textLabel.TextScaled = true
    textLabel.TextWrapped = true -- Tự xuống dòng nếu quá dài
    textLabel.Parent = frame

    -- Thêm thông báo vào danh sách
    table.insert(notifications, frame)

    -- Xóa thông báo sau thời gian hiển thị với hiệu ứng
    task.delay(duration, function()
        -- Tween để chạy lên và biến mất
        local goal = {Position = frame.Position - UDim2.new(0, 0, 0.1, 0), BackgroundTransparency = 1}
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(frame, tweenInfo, goal)

        tween:Play()
        tween.Completed:Wait() -- Đợi tween hoàn thành
        frame:Destroy()

        -- Xóa khỏi danh sách
        table.remove(notifications, table.find(notifications, frame))

        -- Dịch chuyển các thông báo còn lại lên trên
        for i, notif in ipairs(notifications) do
            local targetPosition = UDim2.new(0.325, 0, 0.1 + ((i - 1) * 0.1), 0)
            TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition}):Play()
        end
    end)
end

return th