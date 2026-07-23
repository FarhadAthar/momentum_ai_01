const express = require("express");
const dotenv = require("dotenv");
const cors = require("cors");
const { PrismaClient } = require("@prisma/client");
const authRoutes = require("./routes/authRoutes");
const { protect } = require("./middlewares/authMiddleware");
// 🔥 Crypto import add kiya (Unique ID generate karne ke liye)
const crypto = require("crypto");

dotenv.config();

const prisma = new PrismaClient();

const app = express();
app.use(cors());
app.use(express.json());

// Database Connection check
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

// --- Auth Routes ---
app.use("/api/auth", authRoutes);

// --- DYNAMIC ROUTES ---
app.get("/api/dashboard", protect, (req, res) => {
  if (!req.user) return res.status(401).json({ message: "Unauthorized user" });
  res.status(200).json({
    userName: req.user.name,
    notificationCount: 2,
    dailyFocusScore: 82,
    weeklyFocusIncrease: 6,
    tasksCompleted: 4,
    totalTasks: 8,
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
// 🔥 TASKS ROUTES (Real ID generation)
// ==========================================

app.get("/api/tasks", protect, (req, res) => {
  res.status(200).json({
    tasks: [
      {
        id: "1",
        title: "Prepare client proposal",
        isCompleted: false,
        priority: "High",
        tags: ["Work"],
        time: "Today 5 PM",
        isAIGenerated: true,
        accentColor: "#6366F1",
      },
    ],
  });
});

// 🔥 POST /api/tasks - Naya task banayein (with Real ID)
app.post("/api/tasks", protect, (req, res) => {
  const newTask = req.body;
  // Realistic ID generate karein
  const id = crypto.randomBytes(4).toString("hex");
  const taskWithId = { id, ...newTask };

  res.status(201).json({
    message: "Task created",
    task: taskWithId,
  });
});

// 🔥 PUT /api/tasks/:id/toggle
app.put("/api/tasks/:id/toggle", protect, (req, res) => {
  res.status(200).json({ message: "Task toggled successfully" });
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

// 404 JSON Handler
app.use((req, res, next) => {
  res
    .status(404)
    .json({ message: "Endpoint not found. Please check the URL." });
});

const PORT = process.env.PORT || 5000;
app.listen(5000, "0.0.0.0", () => {
  console.log(`🚀 Server running on port 5000`);
});
