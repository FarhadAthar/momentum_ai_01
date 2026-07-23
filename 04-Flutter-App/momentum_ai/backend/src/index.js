const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const { PrismaClient } = require("@prisma/client");
const authRoutes = require("./routes/authRoutes");
const { protect } = require("./middlewares/authMiddleware");

dotenv.config();

const prisma = new PrismaClient();

const app = express();
app.use(cors());
app.use(express.json());

async function main() {
  try {
    await prisma.$connect();
    console.log("✅ PostgreSQL Connected Successfully");
  } catch (e) {
    console.error("❌ DB Connection Error:", e);
    process.exit(1);
  }
}
main();

// --- Routes ---
app.use("/api/auth", authRoutes);

app.get("/api/dashboard", protect, async (req, res) => {
  if (!req.user) return res.status(401).json({ message: "Unauthorized user" });

  const tasks = await prisma.task.findMany({ where: { userId: req.user.id } });
  const totalTasks = tasks.length;
  const completedTasks = tasks.filter((t) => t.isCompleted).length;

  res.status(200).json({
    userName: req.user.name,
    notificationCount: 2,
    dailyFocusScore: 82,
    weeklyFocusIncrease: 6,
    tasksCompleted: completedTasks,
    totalTasks: totalTasks,
    focusHours: "3.5h",
    streak: 12,
    xp: 350,
    meetings: [
      { title: "Team Standup", time: "10:00 AM", peopleCount: 8 },
      { title: "Client Demo", time: "2:30 PM", peopleCount: 4 },
    ],
    priorities: [
      {
        title: "Complete proposal draft",
        timeEstimate: "1.5h",
        type: "urgent",
        tags: ["Work", "URGENT"],
      },
      {
        title: "Review Q3 Report",
        timeEstimate: "45m",
        type: "finance",
        tags: ["Finance"],
      },
    ],
  });
});

// ==========================================
// 🔥 TASKS API
// ==========================================
app.get("/api/tasks", protect, async (req, res) => {
  const tasks = await prisma.task.findMany({
    where: { userId: req.user.id },
    orderBy: { createdAt: "desc" },
  });
  res.status(200).json({ tasks });
});

app.post("/api/tasks", protect, async (req, res) => {
  const { title, priority, tags, time, isAIGenerated, accentColor } = req.body;
  const newTask = await prisma.task.create({
    data: {
      title,
      priority,
      tags,
      time,
      isAIGenerated,
      accentColor,
      userId: req.user.id,
    },
  });
  res.status(201).json({ message: "Task created", task: newTask });
});

app.put("/api/tasks/:id/toggle", protect, async (req, res) => {
  const { id } = req.params;
  const task = await prisma.task.findUnique({
    where: { id, userId: req.user.id },
  });
  if (!task) return res.status(404).json({ message: "Task not found" });

  const updatedTask = await prisma.task.update({
    where: { id },
    data: { isCompleted: !task.isCompleted },
  });
  res.status(200).json({ message: "Toggled", task: updatedTask });
});

app.delete("/api/tasks/:id", protect, async (req, res) => {
  const { id } = req.params;
  await prisma.task.delete({ where: { id, userId: req.user.id } });
  res.status(200).json({ message: "Task deleted successfully" });
});

// ==========================================
// OTHER ROUTES
// ==========================================
app.get("/api/habits", protect, (req, res) => {
  res.status(200).json({
    habits: [
      { id: "1", title: "Read 20 mins", icon: "📚", completed: true },
      { id: "2", title: "Meditate", icon: "🧘", completed: true },
      { id: "3", title: "Workout", icon: "🏋️", completed: false },
      { id: "4", title: "Journal", icon: "✍️", completed: false },
    ],
    weeklyScore: 78,
    bestStreak: 22,
    habitsThisWeek: 47,
  });
});

app.put("/api/habits/:id/toggle", protect, (req, res) => {
  res.status(200).json({ message: "Habit toggled successfully" });
});

app.get("/api/stats", protect, (req, res) => {
  res.status(200).json({ selectedTimeframe: "week" });
});

app.get("/api/calendar/events", protect, (req, res) => {
  res.status(200).json({
    events: [
      { title: "Team Sync", date: "2026-07-22", time: "10:00 AM" },
      { title: "Design Review", date: "2026-07-23", time: "2:00 PM" },
    ],
  });
});

app.get("/api/profile", protect, (req, res) => {
  if (!req.user) return res.status(401).json({ message: "Unauthorized" });
  res.status(200).json({
    id: req.user.id,
    name: req.user.name,
    email: req.user.email,
    role: req.user.role,
    subscription: "free",
    joinDate: "2026-01-15",
  });
});

app.use((req, res) => {
  res
    .status(404)
    .json({ message: "Endpoint not found. Please check the URL." });
});

const PORT = process.env.PORT || 5000;
app.listen(5000, "0.0.0.0", () => {
  console.log(`🚀 Server running on port 5000`);
});
