IF DB_ID(N'RamadanCompanionDb') IS NULL
BEGIN
    CREATE DATABASE RamadanCompanionDb;
END
GO

USE RamadanCompanionDb;
GO

CREATE TABLE dbo.Users
(
    UserId            INT           IDENTITY(1,1) NOT NULL,
    FullName          NVARCHAR(100) NOT NULL,
    Email             NVARCHAR(150) NOT NULL,
    PasswordHash      NVARCHAR(256) NOT NULL,
    Role              NVARCHAR(10)  NOT NULL CONSTRAINT DF_Users_Role DEFAULT N'User',
    PreferredLanguage CHAR(2)       NULL     CONSTRAINT DF_Users_PreferredLanguage DEFAULT 'ar',
    IsActive          BIT           NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT 1,
    CreatedAt         DATETIME2     NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSDATETIME(),
    LastLoginAt       DATETIME2     NULL,

    CONSTRAINT PK_Users PRIMARY KEY (UserId),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT CK_Users_Role CHECK (Role IN (N'User', N'Admin'))
);
GO

CREATE TABLE dbo.ReminderTypes
(
    ReminderTypeId       TINYINT      NOT NULL,
    Code                 VARCHAR(20)  NOT NULL,
    NameAr               NVARCHAR(50) NOT NULL,
    NameEn               NVARCHAR(50) NULL,
    DefaultEnabled       BIT          NOT NULL CONSTRAINT DF_ReminderTypes_DefaultEnabled DEFAULT 1,
    DefaultOffsetMinutes SMALLINT     NULL,
    DefaultFixedTime     TIME         NULL,
    DefaultPlaySound     BIT          NOT NULL CONSTRAINT DF_ReminderTypes_DefaultPlaySound DEFAULT 1,

    CONSTRAINT PK_ReminderTypes PRIMARY KEY (ReminderTypeId),
    CONSTRAINT UQ_ReminderTypes_Code UNIQUE (Code),
    CONSTRAINT CK_ReminderTypes_Timing CHECK (
        DefaultOffsetMinutes IS NULL OR DefaultFixedTime IS NULL
    )
);
GO

CREATE TABLE dbo.RamadanSeasons
(
    SeasonId  INT      IDENTITY(1,1) NOT NULL,
    HijriYear SMALLINT NOT NULL,
    StartDate DATE     NOT NULL,
    DaysCount TINYINT  NOT NULL CONSTRAINT DF_RamadanSeasons_DaysCount DEFAULT 30,

    CONSTRAINT PK_RamadanSeasons PRIMARY KEY (SeasonId),
    CONSTRAINT UQ_RamadanSeasons_HijriYear UNIQUE (HijriYear),
    CONSTRAINT CK_RamadanSeasons_DaysCount CHECK (DaysCount BETWEEN 29 AND 30)
);
GO

CREATE TABLE dbo.FastMissReasons
(
    FastMissReasonId TINYINT      NOT NULL,
    NameAr           NVARCHAR(50) NULL,
    NameEn           NVARCHAR(50) NULL,

    CONSTRAINT PK_FastMissReasons PRIMARY KEY (FastMissReasonId)
);
GO

CREATE TABLE dbo.UserSettings
(
    UserId            INT          NOT NULL,
    Country           NVARCHAR(60) NOT NULL,
    City              NVARCHAR(60) NOT NULL,
    CalculationMethod TINYINT      NOT NULL,
    HijriAdjustment   SMALLINT     NOT NULL CONSTRAINT DF_UserSettings_HijriAdjustment DEFAULT 0,
    UpdatedAt         DATETIME2    NOT NULL CONSTRAINT DF_UserSettings_UpdatedAt DEFAULT SYSDATETIME(),

    CONSTRAINT PK_UserSettings PRIMARY KEY (UserId),
    CONSTRAINT FK_UserSettings_Users FOREIGN KEY (UserId)
        REFERENCES dbo.Users (UserId) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.NotificationSettings
(
    NotificationSettingId INT      IDENTITY(1,1) NOT NULL,
    UserId                INT      NOT NULL,
    ReminderTypeId        TINYINT  NOT NULL,
    IsEnabled             BIT      NOT NULL CONSTRAINT DF_NotificationSettings_IsEnabled DEFAULT 1,
    OffsetMinutes         SMALLINT NULL,
    FixedTime             TIME     NULL,
    PlaySound             BIT      NOT NULL CONSTRAINT DF_NotificationSettings_PlaySound DEFAULT 1,

    CONSTRAINT PK_NotificationSettings PRIMARY KEY (NotificationSettingId),
    CONSTRAINT FK_NotificationSettings_Users FOREIGN KEY (UserId)
        REFERENCES dbo.Users (UserId) ON DELETE CASCADE,
    CONSTRAINT FK_NotificationSettings_ReminderTypes FOREIGN KEY (ReminderTypeId)
        REFERENCES dbo.ReminderTypes (ReminderTypeId) ON DELETE NO ACTION,
    CONSTRAINT UQ_NotificationSettings_User_Type UNIQUE (UserId, ReminderTypeId),
    CONSTRAINT CK_NotificationSettings_Timing CHECK (
        OffsetMinutes IS NULL OR FixedTime IS NULL
    )
);
GO

CREATE TABLE dbo.DailyDuas
(
    DuaId      INT           IDENTITY(1,1) NOT NULL,
    SeasonId   INT           NOT NULL,
    RamadanDay TINYINT       NOT NULL,
    TextAr     NVARCHAR(500) NOT NULL,
    TextEn     NVARCHAR(500) NULL,

    CONSTRAINT PK_DailyDuas PRIMARY KEY (DuaId),
    CONSTRAINT FK_DailyDuas_RamadanSeasons FOREIGN KEY (SeasonId)
        REFERENCES dbo.RamadanSeasons (SeasonId) ON DELETE CASCADE,
    CONSTRAINT UQ_DailyDuas_Season_Day UNIQUE (SeasonId, RamadanDay),
    CONSTRAINT CK_DailyDuas_RamadanDay CHECK (RamadanDay BETWEEN 1 AND 30)
);
GO

CREATE TABLE dbo.QuranPlans
(
    PlanId           INT       IDENTITY(1,1) NOT NULL,
    UserId           INT       NOT NULL,
    SeasonId         INT       NOT NULL,
    TargetKhatmas    TINYINT   NOT NULL CONSTRAINT DF_QuranPlans_TargetKhatmas DEFAULT 1,
    CompletedKhatmas TINYINT   NOT NULL CONSTRAINT DF_QuranPlans_CompletedKhatmas DEFAULT 0,
    LastPage         SMALLINT  NOT NULL CONSTRAINT DF_QuranPlans_LastPage DEFAULT 0,
    StartDay         TINYINT   NOT NULL CONSTRAINT DF_QuranPlans_StartDay DEFAULT 1,
    CreatedAt        DATETIME2 NOT NULL CONSTRAINT DF_QuranPlans_CreatedAt DEFAULT SYSDATETIME(),
    UpdatedAt        DATETIME2 NOT NULL CONSTRAINT DF_QuranPlans_UpdatedAt DEFAULT SYSDATETIME(),

    CONSTRAINT PK_QuranPlans PRIMARY KEY (PlanId),
    CONSTRAINT FK_QuranPlans_Users FOREIGN KEY (UserId)
        REFERENCES dbo.Users (UserId) ON DELETE CASCADE,
    CONSTRAINT FK_QuranPlans_RamadanSeasons FOREIGN KEY (SeasonId)
        REFERENCES dbo.RamadanSeasons (SeasonId) ON DELETE NO ACTION,
    CONSTRAINT UQ_QuranPlans_User_Season UNIQUE (UserId, SeasonId),
    CONSTRAINT CK_QuranPlans_TargetKhatmas CHECK (TargetKhatmas >= 1),
    CONSTRAINT CK_QuranPlans_CompletedKhatmas CHECK (CompletedKhatmas >= 0),
    CONSTRAINT CK_QuranPlans_LastPage CHECK (LastPage BETWEEN 0 AND 604),
    CONSTRAINT CK_QuranPlans_StartDay CHECK (StartDay BETWEEN 1 AND 30)
);
GO

CREATE TABLE dbo.DailyWorshipLogs
(
    WorshipLogId     INT       IDENTITY(1,1) NOT NULL,
    UserId           INT       NOT NULL,
    SeasonId         INT       NOT NULL,
    RamadanDay       TINYINT   NOT NULL,
    Fasted           BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_Fasted DEFAULT 1,
    FastMissReasonId TINYINT   NULL,
    CongFajr         BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_CongFajr DEFAULT 0,
    CongDhuhr        BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_CongDhuhr DEFAULT 0,
    CongAsr          BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_CongAsr DEFAULT 0,
    CongMaghrib      BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_CongMaghrib DEFAULT 0,
    CongIsha         BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_CongIsha DEFAULT 0,
    TarawihRakats    TINYINT   NOT NULL CONSTRAINT DF_DailyWorshipLogs_TarawihRakats DEFAULT 0,
    QiyamRakats      TINYINT   NOT NULL CONSTRAINT DF_DailyWorshipLogs_QiyamRakats DEFAULT 0,
    NawafilRakats    TINYINT   NOT NULL CONSTRAINT DF_DailyWorshipLogs_NawafilRakats DEFAULT 0,
    MorningAdhkar    BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_MorningAdhkar DEFAULT 0,
    EveningAdhkar    BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_EveningAdhkar DEFAULT 0,
    Sadaqah          BIT       NOT NULL CONSTRAINT DF_DailyWorshipLogs_Sadaqah DEFAULT 0,
    UpdatedAt        DATETIME2 NOT NULL CONSTRAINT DF_DailyWorshipLogs_UpdatedAt DEFAULT SYSDATETIME(),

    CONSTRAINT PK_DailyWorshipLogs PRIMARY KEY (WorshipLogId),
    CONSTRAINT FK_DailyWorshipLogs_Users FOREIGN KEY (UserId)
        REFERENCES dbo.Users (UserId) ON DELETE CASCADE,
    CONSTRAINT FK_DailyWorshipLogs_RamadanSeasons FOREIGN KEY (SeasonId)
        REFERENCES dbo.RamadanSeasons (SeasonId) ON DELETE NO ACTION,
    CONSTRAINT FK_DailyWorshipLogs_FastMissReasons FOREIGN KEY (FastMissReasonId)
        REFERENCES dbo.FastMissReasons (FastMissReasonId) ON DELETE NO ACTION,
    CONSTRAINT UQ_DailyWorshipLogs_User_Season_Day UNIQUE (UserId, SeasonId, RamadanDay),
    CONSTRAINT CK_DailyWorshipLogs_RamadanDay CHECK (RamadanDay BETWEEN 1 AND 30),
    CONSTRAINT CK_DailyWorshipLogs_FastMissReason CHECK (
        FastMissReasonId IS NULL OR FastMissReasonId > 0
    )
);
GO

CREATE TABLE dbo.Goals
(
    GoalId      INT            IDENTITY(1,1) NOT NULL,
    UserId      INT            NOT NULL,
    SeasonId    INT            NOT NULL,
    Title       NVARCHAR(100)  NOT NULL,
    Description NVARCHAR(300)  NULL,
    GoalType    TINYINT        NOT NULL,
    Unit        NVARCHAR(30)   NOT NULL,
    TargetValue DECIMAL(10, 2) NOT NULL,
    IsArchived  BIT            NOT NULL CONSTRAINT DF_Goals_IsArchived DEFAULT 0,
    CreatedAt   DATETIME2      NOT NULL CONSTRAINT DF_Goals_CreatedAt DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Goals PRIMARY KEY (GoalId),
    CONSTRAINT FK_Goals_Users FOREIGN KEY (UserId)
        REFERENCES dbo.Users (UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Goals_RamadanSeasons FOREIGN KEY (SeasonId)
        REFERENCES dbo.RamadanSeasons (SeasonId) ON DELETE NO ACTION,
    CONSTRAINT CK_Goals_GoalType CHECK (GoalType IN (1, 2)),
    CONSTRAINT CK_Goals_TargetValue CHECK (TargetValue > 0)
);
GO

CREATE TABLE dbo.QuranReadingLogs
(
    ReadingLogId INT       IDENTITY(1,1) NOT NULL,
    PlanId       INT       NOT NULL,
    RamadanDay   TINYINT   NOT NULL,
    FromPage     SMALLINT  NOT NULL,
    ToPage       SMALLINT  NOT NULL,
    PagesCount   AS        (ToPage - FromPage + 1),
    CreatedAt    DATETIME2 NOT NULL CONSTRAINT DF_QuranReadingLogs_CreatedAt DEFAULT SYSDATETIME(),

    CONSTRAINT PK_QuranReadingLogs PRIMARY KEY (ReadingLogId),
    CONSTRAINT FK_QuranReadingLogs_QuranPlans FOREIGN KEY (PlanId)
        REFERENCES dbo.QuranPlans (PlanId) ON DELETE CASCADE,
    CONSTRAINT CK_QuranReadingLogs_RamadanDay CHECK (RamadanDay BETWEEN 1 AND 30),
    CONSTRAINT CK_QuranReadingLogs_PagesRange CHECK (
        FromPage BETWEEN 1 AND 604
        AND ToPage BETWEEN 1 AND 604
        AND ToPage >= FromPage
    )
);
GO

CREATE TABLE dbo.GoalProgress
(
    ProgressId INT            IDENTITY(1,1) NOT NULL,
    GoalId     INT            NOT NULL,
    RamadanDay TINYINT        NOT NULL,
    Value      DECIMAL(10, 2) NOT NULL CONSTRAINT DF_GoalProgress_Value DEFAULT 0,
    UpdatedAt  DATETIME2      NOT NULL CONSTRAINT DF_GoalProgress_UpdatedAt DEFAULT SYSDATETIME(),

    CONSTRAINT PK_GoalProgress PRIMARY KEY (ProgressId),
    CONSTRAINT FK_GoalProgress_Goals FOREIGN KEY (GoalId)
        REFERENCES dbo.Goals (GoalId) ON DELETE CASCADE,
    CONSTRAINT UQ_GoalProgress_Goal_Day UNIQUE (GoalId, RamadanDay),
    CONSTRAINT CK_GoalProgress_RamadanDay CHECK (RamadanDay BETWEEN 1 AND 30),
    CONSTRAINT CK_GoalProgress_Value CHECK (Value >= 0)
);
GO
