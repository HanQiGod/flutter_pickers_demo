import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/locations_data.dart';
import 'package:flutter_pickers/address_picker/route/address_picker_route.dart'
    as address_route;
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_link_picker_route.dart'
    as multiple_link_route;
import 'package:flutter_pickers/more_pickers/route/multiple_picker_route.dart'
    as multiple_route;
import 'package:flutter_pickers/more_pickers/route/single_picker_route.dart'
    as single_route;
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:flutter_pickers/time_picker/route/date_picker_route.dart'
    as date_route;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'flutter_pickers Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF3F7F6),
        textTheme: Typography.material2021().black.apply(
          bodyColor: const Color(0xFF0F172A),
          displayColor: const Color(0xFF0F172A),
        ),
      ),
      home: const PickerDemoPage(),
    );
  }
}

class PickerDemoPage extends StatefulWidget {
  const PickerDemoPage({super.key});

  @override
  State<PickerDemoPage> createState() => _PickerDemoPageState();
}

class _PickerDemoPageState extends State<PickerDemoPage> {
  static const Color _popupSurface = Color(0xFFFFFFFF);
  static const Color _popupCanvas = Color(0xFFF8FAFC);
  static const Color _popupInk = Color(0xFF0F172A);
  static const Color _popupMuted = Color(0xFF64748B);
  static const Color _popupBorder = Color(0xFFD9E5E2);

  static const Map<String, dynamic> _productData = {
    '数码产品': {
      '手机': ['华为', '小米', '苹果', '三星'],
      '电脑': ['笔记本', '台式机', '平板'],
      '配件': ['充电器', '耳机', '贴膜'],
    },
    '家用电器': {
      '大家电': ['冰箱', '洗衣机', '电视'],
      '厨房电器': ['电饭煲', '微波炉', '烤箱'],
      '生活电器': ['风扇', '吸尘器', '加湿器'],
    },
    '图书音像': {
      '文学': ['小说', '散文', '诗歌'],
      '科技': ['编程', 'AI', '硬件'],
    },
  };

  final List<List<String>> _timeColumns = [
    const ['上午', '下午'],
    List.generate(12, (index) => (index + 1).toString()),
    List.generate(60, (index) => index.toString().padLeft(2, '0')),
    List.generate(60, (index) => index.toString().padLeft(2, '0')),
  ];

  String _province = '四川省';
  String _city = '成都市';
  String _town = '双流区';

  String _provinceOnly = '四川省';
  String _cityOnly = '成都市';

  String _skill = 'Dart';
  String _education = '本科';
  List<String> _multipleSelection = ['上午', '10', '30', '15'];
  List<String> _linkSelection = ['数码产品', '手机', '华为'];
  PDuration _selectedDate = PDuration(
    year: 2024,
    month: 1,
    day: 1,
    hour: 9,
    minute: 30,
    second: 15,
  );

  List<String> _cityCodes = const [];
  List<String> _cityNames = const [];
  String _status = '点击下方按钮，逐项体验 flutter_pickers 的能力。';
  bool _articleMode = false;

  bool get _isArticleMode => _articleMode;

  @override
  void initState() {
    super.initState();
    _cityCodes = Address.getCityCodeByName(
      provinceName: _province,
      cityName: _city,
      townName: _town,
    );
    _cityNames = Address.getCityNameByCode(
      provinceCode: '510000',
      cityCode: '510100',
      townCode: '510104',
    );
  }

  PickerStyle _buildPickerStyle({
    required String title,
    required String badge,
    required String helper,
    required IconData icon,
    required Color accent,
    bool dark = false,
    String confirmLabel = '确认',
    String cancelLabel = '取消',
  }) {
    if (_isArticleMode) {
      return _buildArticlePickerStyle(
        title: title,
        badge: badge,
        helper: helper,
        icon: icon,
        accent: accent,
        dark: dark,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      );
    }

    final topPanel = dark ? const Color(0xFF020617) : _popupSurface;
    final contentPanel = dark ? const Color(0xFF0F172A) : _popupCanvas;
    final infoPanel = dark ? const Color(0xFF111827) : const Color(0xFFF1F5F9);
    final primaryText = dark ? Colors.white : _popupInk;
    final secondaryText = dark ? const Color(0xFFCBD5E1) : _popupMuted;
    final divider = dark ? const Color(0xFF1E293B) : _popupBorder;

    return PickerStyle(
      pickerTitleHeight: 74,
      menuHeight: 82,
      pickerHeight: 248,
      pickerItemHeight: 48,
      backgroundColor: contentPanel,
      textColor: primaryText,
      headDecoration: BoxDecoration(
        color: topPanel,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(bottom: BorderSide(color: divider)),
      ),
      cancelButton: Container(
        margin: const EdgeInsets.only(left: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: dark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dark ? divider : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          cancelLabel,
          style: TextStyle(
            color: secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      commitButton: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accent,
              accent.withValues(alpha: dark ? 0.78 : 0.92),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: dark ? 0.18 : 0.26),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          confirmLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: dark ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    badge,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      menu: Container(
        height: 82,
        color: topPanel,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: infoPanel,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accent.withValues(alpha: dark ? 0.32 : 0.16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: dark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    helper,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.unfold_more_rounded, color: accent, size: 20),
              ],
            ),
          ),
        ),
      ),
      itemOverlay: _PickerSelectionOverlay(accent: accent, dark: dark),
    );
  }

  PickerStyle _buildArticlePickerStyle({
    required String title,
    required String badge,
    required String helper,
    required IconData icon,
    required Color accent,
    bool dark = false,
    String confirmLabel = '确认',
    String cancelLabel = '取消',
  }) {
    final topPanel = dark ? const Color(0xFF131721) : const Color(0xFFFFFCF8);
    final contentPanel = dark
        ? const Color(0xFF1A2230)
        : const Color(0xFFFCF6EE);
    final infoPanel = dark ? const Color(0xFF202A39) : const Color(0xFFF6EBDD);
    final primaryText = dark ? Colors.white : const Color(0xFF1F2937);
    final secondaryText = dark
        ? const Color(0xFFD5DEEA)
        : const Color(0xFF7C5A43);
    final divider = dark ? const Color(0xFF2C3648) : const Color(0xFFE7D6C1);

    return _ArticlePickerStyle(
      pickerTitleHeight: 88,
      menuHeight: 96,
      pickerHeight: 264,
      pickerItemHeight: 50,
      backgroundColor: contentPanel,
      textColor: primaryText,
      textSize: 18,
      headDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
              : const [Color(0xFFFFFCF8), Color(0xFFF5EBDD)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
        border: Border(bottom: BorderSide(color: divider)),
      ),
      cancelButton: Container(
        margin: const EdgeInsets.only(left: 18),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1E293B) : const Color(0xFFF9F1E6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: divider),
        ),
        child: Text(
          cancelLabel,
          style: TextStyle(
            color: secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      commitButton: Container(
        margin: const EdgeInsets.only(right: 18),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: dark ? 0.24 : 0.3),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Text(
          confirmLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: dark ? 0.22 : 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ARTICLE SHOT',
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      menu: Container(
        height: 96,
        color: topPanel,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: infoPanel,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: divider),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: dark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    helper,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.photo_size_select_large_outlined,
                  color: accent,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      itemOverlay: _PickerSelectionOverlay(
        accent: accent,
        dark: dark,
        editorial: true,
      ),
    );
  }

  PickerStyle _preparePickerStyle(PickerStyle style) {
    style.context ??= context;
    return style;
  }

  String get _modalBarrierLabel =>
      MaterialLocalizations.of(context).modalBarrierDismissLabel;

  void _showAddressPicker() {
    Navigator.of(context).push(
      _FloatingAddressPickerRoute(
        initProvince: _province,
        initCity: _city,
        initTown: _town,
        addAllItem: true,
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '省市区三级联动',
            badge: '地址选择',
            helper: '滚动定位目标地区，确认后会立即更新编码和结果展示。',
            icon: Icons.map_rounded,
            accent: const Color(0xFF0F766E),
          ),
        ),
        onConfirm: (province, city, town) {
          setState(() {
            _province = province;
            _city = city;
            _town = town ?? '';
            _cityCodes = Address.getCityCodeByName(
              provinceName: _province,
              cityName: _city,
              townName: _town,
            );
            _status = '地址选择完成：$_province - $_city - $_town';
          });
        },
      ),
    );
  }

  void _showCityPicker() {
    Navigator.of(context).push(
      _FloatingAddressPickerRoute(
        initProvince: _provinceOnly,
        initCity: _cityOnly,
        initTown: null,
        addAllItem: true,
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '只选择到市',
            badge: '二级联动',
            helper: '保留省市两级选择，更适合城市范围筛选这类场景。',
            icon: Icons.location_city_rounded,
            accent: const Color(0xFFEA580C),
            confirmLabel: '应用',
          ),
        ),
        onConfirm: (province, city, town) {
          setState(() {
            _provinceOnly = province;
            _cityOnly = city;
            _status = '二级地址选择完成：$_provinceOnly - $_cityOnly';
          });
        },
      ),
    );
  }

  void _showStyledAddressPicker() {
    Navigator.of(context).push(
      _FloatingAddressPickerRoute(
        initProvince: _province,
        initCity: _city,
        initTown: _town,
        addAllItem: false,
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '自定义地址样式',
            badge: '夜间模式',
            helper: '强化对比度、按钮层级和选中边界，让暗色弹窗不再发闷。',
            icon: Icons.dark_mode_rounded,
            accent: const Color(0xFF38BDF8),
            dark: true,
            confirmLabel: '保存',
            cancelLabel: '返回',
          ),
        ),
        onConfirm: (province, city, town) {
          setState(() {
            _province = province;
            _city = city;
            _town = town ?? '';
            _cityCodes = Address.getCityCodeByName(
              provinceName: _province,
              cityName: _city,
              townName: _town,
            );
            _status = '暗色自定义样式选择完成：$_province - $_city - $_town';
          });
        },
      ),
    );
  }

  void _showSkillPicker() {
    Navigator.of(context).push(
      _FloatingSinglePickerRoute(
        data: ['PHP', 'JAVA', 'C++', 'Dart', 'Python', 'Go'],
        selectData: _skill,
        suffix: ' 技术栈',
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '单项选择器',
            badge: '技术栈',
            helper: '适合这类单列枚举数据，确认动作比原始默认样式更清晰。',
            icon: Icons.code_rounded,
            accent: const Color(0xFF0F766E),
            confirmLabel: '选好了',
          ),
        ),
        onConfirm: (data, position) {
          setState(() {
            _skill = data.toString();
            _status = '单项选择器已更新：$_skill';
          });
        },
      ),
    );
  }

  void _showEducationPicker() {
    Navigator.of(context).push(
      _FloatingSinglePickerRoute(
        data: PickerDataType.education,
        selectData: _education,
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '内置预设数据',
            badge: '学历预设',
            helper: '直接复用库内置的数据源，同时保持统一的新版弹窗视觉。',
            icon: Icons.school_rounded,
            accent: const Color(0xFF2563EB),
          ),
        ),
        onConfirm: (data, position) {
          setState(() {
            _education = data.toString();
            _status = '内置学历预设已更新：$_education';
          });
        },
      ),
    );
  }

  void _showMultiPicker() {
    Navigator.of(context).push(
      _FloatingMultiPickerRoute(
        data: _timeColumns,
        selectData: _multipleSelection,
        suffix: const ['', '时', '分', '秒'],
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '多项时间选择',
            badge: '时分秒',
            helper: '多列并排时增加说明区和高亮选区，阅读负担会明显更小。',
            icon: Icons.schedule_rounded,
            accent: const Color(0xFF0EA5E9),
            confirmLabel: '更新时间',
          ),
        ),
        onConfirm: (res, position) {
          setState(() {
            _multipleSelection = List<String>.from(
              res.map((item) => item.toString()),
            );
            _status = '多项选择器已更新：${_multipleSelection.join(' ')}';
          });
        },
      ),
    );
  }

  void _showMultiLinkPicker() {
    Navigator.of(context).push(
      _FloatingMultiLinkPickerRoute(
        data: _productData,
        columnNum: 3,
        selectData: _linkSelection,
        suffix: const ['', '', ''],
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '自定义联动选择器',
            badge: '商品分类',
            helper: '联动列之间保持统一节奏，当前所在层级和确认动作更容易识别。',
            icon: Icons.account_tree_rounded,
            accent: const Color(0xFFF97316),
            confirmLabel: '确认分类',
          ),
        ),
        onConfirm: (res, position) {
          setState(() {
            _linkSelection = List<String>.from(
              res.map((item) => item.toString()),
            );
            _status = '联动选择器已更新：${_linkSelection.join(' - ')}';
          });
        },
      ),
    );
  }

  void _showDatePicker() {
    Navigator.of(context).push(
      _FloatingDatePickerRoute(
        mode: DateMode.YMDHMS,
        initDate: _copyDuration(_selectedDate),
        minDate: PDuration(year: 2020),
        maxDate: PDuration(
          year: 2030,
          month: 12,
          day: 31,
          hour: 23,
          minute: 59,
          second: 59,
        ),
        suffix: Suffix(
          years: '年',
          month: '月',
          days: '日',
          hours: '时',
          minutes: '分',
          seconds: '秒',
        ),
        theme: Theme.of(context),
        barrierLabel: _modalBarrierLabel,
        pickerStyle: _preparePickerStyle(
          _buildPickerStyle(
            title: '时间选择器',
            badge: '日期时间',
            helper: '用更明确的顶部信息和选中态承载长字段时间滚轮。',
            icon: Icons.event_rounded,
            accent: const Color(0xFF14B8A6),
            confirmLabel: '确认时间',
          ),
        ),
        onConfirm: (value) {
          setState(() {
            _selectedDate = _copyDuration(value);
            _status = '时间选择器已更新：${_formatDuration(_selectedDate)}';
          });
        },
      ),
    );
  }

  void _queryCodeByName() {
    final codes = Address.getCityCodeByName(
      provinceName: _province,
      cityName: _city,
      townName: _town,
    );
    setState(() {
      _cityCodes = codes;
      _status = '根据名称查询城市码完成：${codes.join(' / ')}';
    });
  }

  void _queryNameByCode() {
    final names = Address.getCityNameByCode(
      provinceCode: '510000',
      cityCode: '510100',
      townCode: '510104',
    );
    setState(() {
      _cityNames = names;
      _status = '根据编码查询城市名完成：${names.join(' / ')}';
    });
  }

  PDuration _copyDuration(PDuration value) {
    return PDuration(
      year: value.year ?? 0,
      month: value.month ?? 0,
      day: value.day ?? 0,
      hour: value.hour ?? 0,
      minute: value.minute ?? 0,
      second: value.second ?? 0,
    );
  }

  String _formatDuration(PDuration value) {
    final year = (value.year ?? 0).toString().padLeft(4, '0');
    final month = (value.month ?? 0).toString().padLeft(2, '0');
    final day = (value.day ?? 0).toString().padLeft(2, '0');
    final hour = (value.hour ?? 0).toString().padLeft(2, '0');
    final minute = (value.minute ?? 0).toString().padLeft(2, '0');
    final second = (value.second ?? 0).toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }

  String _formatList(List<String> values) {
    if (values.isEmpty) {
      return '暂无结果';
    }
    return values.join(' / ');
  }

  Widget _buildModeSwitch() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _isArticleMode
            ? const Color(0xFFF9F2E7).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isArticleMode
              ? const Color(0xFFE7D6C1)
              : const Color(0xFFD7E4E1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModePill(
              active: !_isArticleMode,
              title: '交互演示',
              subtitle: '保留常规 demo 结构',
              accent: const Color(0xFF0F766E),
              onTap: () => setState(() => _articleMode = false),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ModePill(
              active: _isArticleMode,
              title: '文章配图',
              subtitle: '更适合截图发文',
              accent: const Color(0xFFB45309),
              onTap: () => setState(() => _articleMode = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoHero(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F766E), Color(0xFF0EA5E9)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F766E),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'flutter_pickers Demo',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '内置省市区数据，开箱即用的全能选择器库。',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FeatureBadge(label: '地址联动'),
              _FeatureBadge(label: '单项 / 多项'),
              _FeatureBadge(label: '16 种时间模式'),
              _FeatureBadge(label: '城市码查询'),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Text(
              _status,
              style: const TextStyle(color: Colors.white, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleHero(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF162033), Color(0xFF0F766E), Color(0xFFB45309)],
          stops: [0.0, 0.58, 1.0],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33162033),
            blurRadius: 36,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: const Text(
                  'ARTICLE SHOT KIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '1080 x 1350',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'flutter_pickers\n文章配图版',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '同一套交互，额外补一层更适合截图发文的版式与弹窗视觉。现在不仅能演示，还能直接拿去做文章配图。',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FeatureBadge(label: '封面区可用', editorial: true),
              _FeatureBadge(label: '弹窗截图优化', editorial: true),
              _FeatureBadge(label: '结果卡片可读', editorial: true),
              _FeatureBadge(label: '适合长图发文', editorial: true),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Text(
              _status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleShotStage(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 760;

        final preview = Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFCF8), Color(0xFFF5EBDD)],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFE7D6C1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '推荐截图构图',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '把标题、弹窗和结果卡片同时纳入画面，文章配图的信息密度会更完整。',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF7C5A43),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              _EditorialSnapshotCard(
                kicker: '地址选择结果',
                title: '$_province / $_city / $_town',
                accent: const Color(0xFF0F766E),
                detail: '城市编码：${_formatList(_cityCodes)}',
              ),
              const SizedBox(height: 12),
              _EditorialSnapshotCard(
                kicker: '联动分类结果',
                title: _linkSelection.join(' - '),
                accent: const Color(0xFFEA580C),
                detail:
                    '时间组合：${_multipleSelection[0]} ${_multipleSelection[1]}:${_multipleSelection[2]}:${_multipleSelection[3]}',
              ),
              const SizedBox(height: 12),
              _EditorialSnapshotCard(
                kicker: '时间与预设',
                title: _formatDuration(_selectedDate),
                accent: const Color(0xFF2563EB),
                detail: '技术栈：$_skill  ·  学历：$_education',
              ),
            ],
          ),
        );

        final controls = Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF161B24),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF293548)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '截图直出建议',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '推荐在文章配图模式下打开弹窗，再截取顶部标题 + 中间滚轮选区 + 底部结果卡片的组合画面。',
                style: TextStyle(color: Color(0xFFD5DEEA), height: 1.55),
              ),
              const SizedBox(height: 16),
              _ActionChipButton(
                icon: Icons.map_outlined,
                label: '拍地址选择器',
                onPressed: _showAddressPicker,
                editorial: true,
              ),
              const SizedBox(height: 10),
              _ActionChipButton(
                icon: Icons.account_tree_outlined,
                label: '拍联动分类弹窗',
                onPressed: _showMultiLinkPicker,
                editorial: true,
              ),
              const SizedBox(height: 10),
              _ActionChipButton(
                icon: Icons.event_outlined,
                label: '拍时间选择器',
                onPressed: _showDatePicker,
                editorial: true,
              ),
              const SizedBox(height: 18),
              const _ShotTip(
                title: '构图建议',
                content: '标题保留在上三分之一，弹窗本体居中，结果卡片留在底部承接说明。',
              ),
              const SizedBox(height: 10),
              const _ShotTip(
                title: '文字建议',
                content: '正文配图更适合 2 到 4 行说明，不要把按钮和说明同时堆满整屏。',
              ),
            ],
          ),
        );

        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.64),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: const Color(0xFFE9DED2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14162033),
                blurRadius: 26,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: narrow
              ? Column(
                  children: [preview, const SizedBox(height: 16), controls],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: preview),
                    const SizedBox(width: 16),
                    Expanded(flex: 5, child: controls),
                  ],
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editorial = _isArticleMode;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _PageBackdrop(editorial: editorial)),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                _buildModeSwitch(),
                const SizedBox(height: 16),
                editorial ? _buildArticleHero(theme) : _buildDemoHero(theme),
                if (editorial) ...[
                  const SizedBox(height: 16),
                  _buildArticleShotStage(theme),
                ],
                const SizedBox(height: 18),
                _DemoCard(
                  title: '地址选择器',
                  subtitle: '覆盖文章里的三级联动、二级联动和样式定制场景。',
                  editorial: editorial,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ActionChipButton(
                            icon: Icons.map_outlined,
                            label: '省市区三级联动',
                            onPressed: _showAddressPicker,
                            editorial: editorial,
                          ),
                          _ActionChipButton(
                            icon: Icons.location_city_outlined,
                            label: '只选省市',
                            onPressed: _showCityPicker,
                            editorial: editorial,
                          ),
                          _ActionChipButton(
                            icon: Icons.palette_outlined,
                            label: '自定义暗色样式',
                            onPressed: _showStyledAddressPicker,
                            editorial: editorial,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoTile(
                        label: '当前省市区',
                        value: '$_province - $_city - $_town',
                        editorial: editorial,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        label: '当前省市',
                        value: '$_provinceOnly - $_cityOnly',
                        editorial: editorial,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        label: '已使用样式',
                        value: '统一品牌弹窗 / 顶部说明区 / 高亮选中层',
                        editorial: editorial,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _DemoCard(
                  title: '城市码查询工具',
                  subtitle: '根据名称查编码，也能根据编码反查城市名。',
                  editorial: editorial,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ActionChipButton(
                            icon: Icons.pin_drop_outlined,
                            label: '名称查城市码',
                            onPressed: _queryCodeByName,
                            editorial: editorial,
                          ),
                          _ActionChipButton(
                            icon: Icons.tag_outlined,
                            label: '编码查城市名',
                            onPressed: _queryNameByCode,
                            editorial: editorial,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoTile(
                        label: '$_province / $_city / $_town',
                        value: _formatList(_cityCodes),
                        editorial: editorial,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        label: '510000 / 510100 / 510104',
                        value: _formatList(_cityNames),
                        editorial: editorial,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _DemoCard(
                  title: '单项选择与内置预设',
                  subtitle: '同时展示通用单选和内置数据源的开箱即用能力。',
                  editorial: editorial,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ActionChipButton(
                            icon: Icons.code_outlined,
                            label: '选择技术栈',
                            onPressed: _showSkillPicker,
                            editorial: editorial,
                          ),
                          _ActionChipButton(
                            icon: Icons.school_outlined,
                            label: '选择学历',
                            onPressed: _showEducationPicker,
                            editorial: editorial,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoTile(
                        label: '技术栈结果',
                        value: _skill,
                        editorial: editorial,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        label: '学历结果',
                        value: _education,
                        editorial: editorial,
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MiniTag(label: 'sex', editorial: editorial),
                          _MiniTag(label: 'education', editorial: editorial),
                          _MiniTag(label: 'subject', editorial: editorial),
                          _MiniTag(
                            label: 'constellation',
                            editorial: editorial,
                          ),
                          _MiniTag(label: 'zodiac', editorial: editorial),
                          _MiniTag(label: 'ethnicity', editorial: editorial),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _DemoCard(
                  title: '多项选择与联动',
                  subtitle: '适合时分秒、多列独立数据以及 Map 嵌套联动数据。',
                  editorial: editorial,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ActionChipButton(
                            icon: Icons.schedule_outlined,
                            label: '多项时间选择',
                            onPressed: _showMultiPicker,
                            editorial: editorial,
                          ),
                          _ActionChipButton(
                            icon: Icons.account_tree_outlined,
                            label: '商品分类联动',
                            onPressed: _showMultiLinkPicker,
                            editorial: editorial,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoTile(
                        label: '多项选择结果',
                        value:
                            '${_multipleSelection[0]} ${_multipleSelection[1]}时'
                            '${_multipleSelection[2]}分${_multipleSelection[3]}秒',
                        editorial: editorial,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        label: '联动选择结果',
                        value: _linkSelection.join(' - '),
                        editorial: editorial,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        label: '联动数据结构',
                        value: 'Map -> Map -> List，和文章里的商品分类示例一致。',
                        editorial: editorial,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _DemoCard(
                  title: '时间选择器',
                  subtitle: '当前示例使用 YMDHMS 模式，支持最小和最大时间限制。',
                  editorial: editorial,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ActionChipButton(
                        icon: Icons.event_outlined,
                        label: '打开时间选择器',
                        onPressed: _showDatePicker,
                        editorial: editorial,
                      ),
                      const SizedBox(height: 16),
                      _InfoTile(
                        label: '当前时间结果',
                        value: _formatDuration(_selectedDate),
                        editorial: editorial,
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MiniTag(label: 'YMDHMS', editorial: editorial),
                          _MiniTag(label: 'YMDHM', editorial: editorial),
                          _MiniTag(label: 'YMD', editorial: editorial),
                          _MiniTag(label: 'YM', editorial: editorial),
                          _MiniTag(label: 'MD', editorial: editorial),
                          _MiniTag(label: 'HM', editorial: editorial),
                          _MiniTag(label: 'HMS', editorial: editorial),
                          _MiniTag(label: '共 16 种模式', editorial: editorial),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticlePickerStyle extends PickerStyle {
  _ArticlePickerStyle({
    super.menu,
    super.pickerHeight,
    super.pickerTitleHeight,
    super.pickerItemHeight,
    super.menuHeight,
    super.cancelButton,
    super.commitButton,
    super.title,
    super.headDecoration,
    super.backgroundColor,
    super.textColor,
    super.textSize,
    super.itemOverlay,
  });
}

class _PageBackdrop extends StatelessWidget {
  const _PageBackdrop({required this.editorial});

  final bool editorial;

  @override
  Widget build(BuildContext context) {
    if (!editorial) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F7F3), Color(0xFFF7FBFA)],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF7EEDF), Color(0xFFF6FBFA), Color(0xFFE9F4F2)],
            ),
          ),
        ),
        Positioned(
          top: -80,
          left: -40,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0F766E).withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          top: 120,
          right: -60,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEA580C).withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: 40,
          right: 40,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF162033).withValues(alpha: 0.08),
                  const Color(0xFF0F766E).withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.active,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final bool active;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: active ? accent : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: active
                      ? Colors.white.withValues(alpha: 0.84)
                      : const Color(0xFF64748B),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorialSnapshotCard extends StatelessWidget {
  const _EditorialSnapshotCard({
    required this.kicker,
    required this.title,
    required this.accent,
    required this.detail,
  });

  final String kicker;
  final String title;
  final Color accent;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kicker,
            style: TextStyle(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF7C5A43),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShotTip extends StatelessWidget {
  const _ShotTip({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(color: Color(0xFFD5DEEA), height: 1.5),
          ),
        ],
      ),
    );
  }
}

double _pickerDialogHeight(PickerStyle style) {
  var height = style.pickerHeight;
  if (style.showTitleBar) {
    height += style.pickerTitleHeight;
  }
  if (style.menu != null) {
    height += style.menuHeight;
  }
  return height;
}

Widget _buildFloatingPickerPage({
  required BuildContext context,
  required Animation<double> animation,
  required PickerStyle pickerStyle,
  required Widget child,
  ThemeData? theme,
}) {
  Widget page = MediaQuery.removePadding(
    context: context,
    removeTop: true,
    child: child,
  );

  if (theme != null) {
    page = Theme(data: theme, child: page);
  }

  final content = page;
  page = Builder(
    builder: (pageContext) {
      final cupertinoTheme = CupertinoTheme.of(pageContext);
      final cupertinoTextTheme = cupertinoTheme.textTheme;
      final pickerTextStyle = cupertinoTextTheme.pickerTextStyle.copyWith(
        color: pickerStyle.textColor,
        fontSize:
            pickerStyle.textSize ?? cupertinoTextTheme.pickerTextStyle.fontSize,
      );

      return CupertinoTheme(
        data: cupertinoTheme.copyWith(
          textTheme: cupertinoTextTheme.copyWith(
            textStyle: cupertinoTextTheme.textStyle.copyWith(
              color: pickerStyle.textColor,
            ),
            pickerTextStyle: pickerTextStyle,
            dateTimePickerTextStyle: cupertinoTextTheme.dateTimePickerTextStyle
                .copyWith(color: pickerStyle.textColor),
          ),
        ),
        child: content,
      );
    },
  );

  return _PickerDialogShell(
    animation: animation,
    pickerStyle: pickerStyle,
    child: page,
  );
}

class _FloatingAddressPickerRoute<T>
    extends address_route.AddressPickerRoute<T> {
  _FloatingAddressPickerRoute({
    required super.addAllItem,
    required super.pickerStyle,
    required super.initProvince,
    required super.initCity,
    super.initTown,
    super.onChanged,
    super.onConfirm,
    super.onCancel,
    super.theme,
    super.barrierLabel,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 280);

  @override
  Color get barrierColor => const Color(0x70101828);

  @override
  AnimationController createAnimationController() {
    final controller = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    controller.duration = transitionDuration;
    controller.reverseDuration = const Duration(milliseconds: 220);
    return controller;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _buildFloatingPickerPage(
      context: context,
      animation: animation,
      pickerStyle: pickerStyle,
      theme: theme,
      child: address_route.PickerContentView(
        initProvince: initProvince,
        initCity: initCity,
        initTown: initTown,
        addAllItem: addAllItem,
        pickerStyle: pickerStyle,
        route: this,
      ),
    );
  }
}

class _FloatingSinglePickerRoute<T> extends single_route.SinglePickerRoute<T> {
  _FloatingSinglePickerRoute({
    required super.data,
    super.selectData,
    super.suffix,
    required super.pickerStyle,
    super.onChanged,
    super.onConfirm,
    super.onCancel,
    required super.theme,
    super.barrierLabel,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 280);

  @override
  Color get barrierColor => const Color(0x70101828);

  @override
  AnimationController createAnimationController() {
    final controller = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    controller.duration = transitionDuration;
    controller.reverseDuration = const Duration(milliseconds: 220);
    return controller;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    List items = [];
    if (data is PickerDataType) {
      items = pickerData[data]!;
    } else if (data is List) {
      items.addAll(data as List);
    }

    return _buildFloatingPickerPage(
      context: context,
      animation: animation,
      pickerStyle: pickerStyle,
      theme: theme,
      child: single_route.PickerContentView(
        data: items,
        selectData: selectData,
        pickerStyle: pickerStyle,
        route: this,
      ),
    );
  }
}

class _FloatingMultiPickerRoute<T>
    extends multiple_route.MultiplePickerRoute<T> {
  _FloatingMultiPickerRoute({
    required super.pickerStyle,
    required super.data,
    required super.selectData,
    super.suffix,
    super.onChanged,
    super.onConfirm,
    super.onCancel,
    super.theme,
    super.barrierLabel,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 280);

  @override
  Color get barrierColor => const Color(0x70101828);

  @override
  AnimationController createAnimationController() {
    final controller = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    controller.duration = transitionDuration;
    controller.reverseDuration = const Duration(milliseconds: 220);
    return controller;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _buildFloatingPickerPage(
      context: context,
      animation: animation,
      pickerStyle: pickerStyle,
      theme: theme,
      child: multiple_route.PickerContentView(
        data: data,
        selectData: selectData,
        pickerStyle: pickerStyle,
        route: this,
      ),
    );
  }
}

class _FloatingMultiLinkPickerRoute<T>
    extends multiple_link_route.MultipleLinkPickerRoute<T> {
  _FloatingMultiLinkPickerRoute({
    required super.pickerStyle,
    required super.data,
    required super.selectData,
    required super.columnNum,
    super.suffix,
    super.onChanged,
    super.onConfirm,
    super.onCancel,
    super.theme,
    super.barrierLabel,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 280);

  @override
  Color get barrierColor => const Color(0x70101828);

  @override
  AnimationController createAnimationController() {
    final controller = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    controller.duration = transitionDuration;
    controller.reverseDuration = const Duration(milliseconds: 220);
    return controller;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _buildFloatingPickerPage(
      context: context,
      animation: animation,
      pickerStyle: pickerStyle,
      theme: theme,
      child: multiple_link_route.PickerContentView(
        data: data,
        columnNum: columnNum,
        selectData: selectData,
        pickerStyle: pickerStyle,
        route: this,
      ),
    );
  }
}

class _FloatingDatePickerRoute<T> extends date_route.DatePickerRoute<T> {
  _FloatingDatePickerRoute({
    required super.mode,
    required super.initDate,
    required PickerStyle pickerStyle,
    required super.maxDate,
    required super.minDate,
    super.suffix,
    super.onChanged,
    super.onConfirm,
    super.onCancel,
    super.theme,
    super.barrierLabel,
    super.settings,
  }) : super(pickerStyle: pickerStyle);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 280);

  @override
  Color get barrierColor => const Color(0x70101828);

  @override
  AnimationController createAnimationController() {
    final controller = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    controller.duration = transitionDuration;
    controller.reverseDuration = const Duration(milliseconds: 220);
    return controller;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _buildFloatingPickerPage(
      context: context,
      animation: animation,
      pickerStyle: pickerStyle!,
      theme: theme,
      child: date_route.PickerContentView(
        mode: mode,
        initData: initDate,
        maxDate: maxDate,
        minDate: minDate,
        pickerStyle: pickerStyle!,
        route: this,
      ),
    );
  }
}

class _PickerDialogShell extends StatelessWidget {
  const _PickerDialogShell({
    required this.animation,
    required this.pickerStyle,
    required this.child,
  });

  final Animation<double> animation;
  final PickerStyle pickerStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final editorial = pickerStyle is _ArticlePickerStyle;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInQuad,
    );
    final height = _pickerDialogHeight(pickerStyle);
    final radius = editorial ? 38.0 : 32.0;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 24, 14, 12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FadeTransition(
            opacity: curved,
            child: AnimatedBuilder(
              animation: curved,
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0, (1 - curved.value) * 18),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: editorial ? 620 : 560,
                    ),
                    child: SizedBox(
                      height: height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          boxShadow: [
                            BoxShadow(
                              color: editorial
                                  ? const Color(0x2A2A1B0F)
                                  : const Color(0x33101828),
                              blurRadius: editorial ? 52 : 42,
                              offset: Offset(0, editorial ? 22 : 18),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(radius),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: editorial
                                        ? const [
                                            Color(0xFFFFFBF5),
                                            Color(0xFFF1E5D6),
                                          ]
                                        : const [
                                            Color(0xFFF8FBFC),
                                            Color(0xFFEDF4F3),
                                          ],
                                  ),
                                ),
                              ),
                              child,
                              Positioned(
                                top: 10,
                                left: 0,
                                right: 0,
                                child: IgnorePointer(
                                  child: Center(
                                    child: Container(
                                      width: 42,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color:
                                            (editorial
                                                    ? const Color(0xFFD4B08A)
                                                    : const Color(0xFFB8C6D4))
                                                .withValues(alpha: 0.78),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: IgnorePointer(
                                  child: Container(
                                    height: editorial ? 72 : 58,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          (editorial
                                                  ? const Color(0xFFFFF6EA)
                                                  : Colors.white)
                                              .withValues(alpha: 0.28),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (editorial)
                                Positioned(
                                  top: -30,
                                  right: -20,
                                  child: IgnorePointer(
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(
                                          0xFFEA580C,
                                        ).withValues(alpha: 0.08),
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        radius,
                                      ),
                                      border: Border.all(
                                        color:
                                            (editorial
                                                    ? const Color(0xFFFFF7EE)
                                                    : Colors.white)
                                                .withValues(alpha: 0.58),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerSelectionOverlay extends StatelessWidget {
  const _PickerSelectionOverlay({
    required this.accent,
    required this.dark,
    this.editorial = false,
  });

  final Color accent;
  final bool dark;
  final bool editorial;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: editorial ? 12 : 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: editorial
                  ? (dark
                        ? accent.withValues(alpha: 0.14)
                        : accent.withValues(alpha: 0.06))
                  : dark
                  ? accent.withValues(alpha: 0.12)
                  : accent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(editorial ? 24 : 20),
              border: Border.all(
                color: accent.withValues(
                  alpha: editorial ? (dark ? 0.58 : 0.3) : (dark ? 0.46 : 0.22),
                ),
                width: editorial ? 1.6 : 1.4,
              ),
              boxShadow: dark
                  ? const []
                  : [
                      BoxShadow(
                        color: accent.withValues(
                          alpha: editorial ? 0.16 : 0.12,
                        ),
                        blurRadius: editorial ? 26 : 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(editorial ? 24 : 20),
                      gradient: LinearGradient(
                        colors: [
                          accent.withValues(
                            alpha: editorial
                                ? (dark ? 0.08 : 0.04)
                                : (dark ? 0.06 : 0.03),
                          ),
                          Colors.transparent,
                          accent.withValues(
                            alpha: editorial
                                ? (dark ? 0.08 : 0.03)
                                : (dark ? 0.06 : 0.02),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (editorial)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 6,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: dark ? 0.62 : 0.32),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: editorial ? 6 : 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: accent.withValues(
                        alpha: editorial
                            ? (dark ? 0.62 : 0.32)
                            : (dark ? 0.5 : 0.22),
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox.expand(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.editorial = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool editorial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: editorial ? const Color(0xFFFFFBF6) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: editorial ? const Color(0xFFE8D9C8) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: editorial
                ? const Color(0x162A1B0F)
                : const Color(0x120F172A),
            blurRadius: editorial ? 28 : 20,
            offset: Offset(0, editorial ? 14 : 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: editorial
                  ? const Color(0xFF7C5A43)
                  : const Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.editorial = false,
  });

  final String label;
  final String value;
  final bool editorial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: editorial ? const Color(0xFFF9F1E6) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: editorial ? const Color(0xFFE7D6C1) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: editorial
                  ? const Color(0xFF9A3412)
                  : const Color(0xFF0F766E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.45,
              color: editorial ? const Color(0xFF1F2937) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.editorial = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool editorial;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: editorial
            ? const Color(0xFF172032)
            : const Color(0xFFDBF2EA),
        foregroundColor: editorial
            ? const Color(0xFFFFF5E9)
            : const Color(0xFF0F766E),
        padding: EdgeInsets.symmetric(
          horizontal: editorial ? 20 : 18,
          vertical: editorial ? 15 : 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: editorial
            ? const BorderSide(color: Color(0xFF314157))
            : BorderSide.none,
        elevation: editorial ? 0 : null,
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.label, this.editorial = false});

  final String label;
  final bool editorial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: editorial
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: editorial ? 0.16 : 0.24),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label, this.editorial = false});

  final String label;
  final bool editorial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: editorial ? const Color(0xFFF8EFE2) : const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: editorial ? const Color(0xFFE7D6C1) : const Color(0xFFA7F3D0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: editorial ? const Color(0xFF9A3412) : const Color(0xFF0F766E),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
