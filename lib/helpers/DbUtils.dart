import 'package:sqflite/sqflite.dart';

class DrawerMenu {
  const DrawerMenu({
    required this.id,
    required this.iconCode,
    required this.menuName,
    required this.menuUrl,
    required this.ordering,
  });

  factory DrawerMenu.fromMap(Map<String, Object?> map) {
    return DrawerMenu(
      id: map['id'] as int,
      iconCode: map['icon_code'] as String? ?? '',
      menuName: map['menu_name'] as String? ?? '',
      menuUrl: map['menu_url'] as String? ?? '',
      ordering: map['ordering']?.toString() ?? '',
    );
  }

  final int id;
  final String iconCode;
  final String menuName;
  final String menuUrl;
  final String ordering;
}

class DbUtils {
  DbUtils._();

  static final DbUtils instance = DbUtils._();

  static const _dbName = 'ueh_student_app.db';
  static const _dbVersion = 2;

  static const tableDrawerNavMenu = 'drawer_nav_menu';

  // icon_code lưu tên icon trong FontAwesomeIcons (vd: 'newspaper' -> FontAwesomeIcons.newspaper).
  static const _initialDrawerMenus = <Map<String, Object?>>[
    {
      'icon_code': 'newspaper',
      'menu_name': 'Tin tức UEH',
      'menu_url': '/news',
      'ordering': '1',
    },
    {
      'icon_code': 'calendarCheck',
      'menu_name': 'Sự kiện UEH',
      'menu_url': '/events',
      'ordering': '2',
    },
    {
      'icon_code': 'chartLine',
      'menu_name': 'Xem điểm',
      'menu_url': '/scores',
      'ordering': '3',
    },
    {
      'icon_code': 'fingerprint',
      'menu_name': 'Định danh khuôn mặt',
      'menu_url': '/face-id',
      'ordering': '4',
    },
    {
      'icon_code': 'calendarDays',
      'menu_name': 'Thời khóa biểu',
      'menu_url': '/timetable',
      'ordering': '5',
    },
    {
      'icon_code': 'clipboardList',
      'menu_name': 'Lịch thi',
      'menu_url': '/exam-schedule',
      'ordering': '6',
    },
    {
      'icon_code': 'heartPulse',
      'menu_name': 'Chăm sóc sức khỏe',
      'menu_url': '/health-care',
      'ordering': '7',
    },
    {
      'icon_code': 'leaf',
      'menu_name': 'UEH Go Green Station',
      'menu_url': '/go-green-station',
      'ordering': '8',
    },
    {
      'icon_code': 'phone',
      'menu_name': 'Liên hệ trực tiếp UEH',
      'menu_url': '/contact',
      'ordering': '9',
    },
    {
      'icon_code': 'coins',
      'menu_name': 'UEH Green Coin',
      'menu_url': '/green-coin',
      'ordering': '10',
    },
    {
      'icon_code': 'solidCircleCheck',
      'menu_name': 'Đã điểm danh',
      'menu_url': '/attendance-history',
      'ordering': '11',
    },
  ];

  Database? _database;

  Future<Database> get database async {
    return _database ??= await _openDb();
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      '$dbPath/$_dbName',
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableDrawerNavMenu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        icon_code TEXT,
        menu_name TEXT,
        menu_url TEXT,
        ordering TEXT
      )
    ''');

    final batch = db.batch();
    for (final menu in _initialDrawerMenus) {
      batch.insert(tableDrawerNavMenu, menu);
    }
    await batch.commit(noResult: true);
  }

  // v1 -> v2: cột ordering đổi từ INTEGER sang TEXT. Bảng chỉ chứa dữ liệu khởi tạo
  // nên tạo lại bảng và nạp lại menu.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS $tableDrawerNavMenu');
      await _onCreate(db, newVersion);
    }
  }

  Future<List<Map<String, Object?>>> getDrawerMenus() async {
    final db = await database;
    return db.query(
      tableDrawerNavMenu,
      orderBy: 'CAST(ordering AS INTEGER) ASC',
    );
  }

  Future<List<DrawerMenu>> loadDrawerMenus() async {
    final rows = await getDrawerMenus();
    return rows.map(DrawerMenu.fromMap).toList();
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
