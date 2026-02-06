import '../models/code_example_model.dart';

/// 代码示例服务
class CodeService {
  /// 获取所有代码示例
  static List<CodeExample> getAllExamples() {
    return _mockData;
  }

  /// 按语言筛选
  static List<CodeExample> getExamplesByLanguage(String language) {
    return _mockData.where((e) => e.language == language).toList();
  }

  /// 按分类筛选
  static List<CodeExample> getExamplesByCategory(String category) {
    return _mockData.where((e) => e.category == category).toList();
  }

  /// 搜索代码
  static List<CodeExample> searchExamples(String query) {
    final lowerQuery = query.toLowerCase();
    return _mockData.where((e) {
      return e.title.toLowerCase().contains(lowerQuery) ||
          e.description.toLowerCase().contains(lowerQuery) ||
          e.code.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// 获取单个示例
  static CodeExample? getExampleById(String id) {
    try {
      return _mockData.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 模拟数据
  static final List<CodeExample> _mockData = [
    // Flutter 示例
    CodeExample(
      id: '1',
      title: '自定义按钮组件',
      description: '一个带有渐变背景和点击动画的自定义按钮',
      language: 'flutter',
      category: 'UI组件',
      createdAt: DateTime.now(),
      code: '''class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> colors;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32, 
          vertical: 16
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}''',
    ),
    CodeExample(
      id: '2',
      title: '列表页面模板',
      description: '带下拉刷新和上拉加载的列表页面',
      language: 'flutter',
      category: '页面模板',
      createdAt: DateTime.now(),
      code: '''class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<String> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      items = List.generate(20, (i) => 'Item \$i');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              leading: Icon(Icons.star),
            );
          },
        ),
      ),
    );
  }
}''',
    ),
    CodeExample(
      id: '3',
      title: '网络请求封装',
      description: '使用 Dio 封装的 HTTP 请求工具类',
      language: 'dart',
      category: '工具类',
      createdAt: DateTime.now(),
      code: '''import 'package:dio/dio.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late Dio _dio;

  factory HttpClient() => _instance;

  HttpClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    ));

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 添加 token
        options.headers['Authorization'] = 'Bearer token';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return await _dio.get(path, queryParameters: params);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}''',
    ),
    // Python 示例
    CodeExample(
      id: '4',
      title: '数据处理脚本',
      description: '使用 pandas 处理 CSV 数据',
      language: 'python',
      category: '数据处理',
      createdAt: DateTime.now(),
      code: '''import pandas as pd
import matplotlib.pyplot as plt

def analyze_data(file_path):
    # 读取 CSV 文件
    df = pd.read_csv(file_path)
    
    # 基本统计信息
    print("数据形状:", df.shape)
    print("\\n数据前5行:")
    print(df.head())
    
    # 数据清洗
    df = df.dropna()  # 删除空值
    df = df.drop_duplicates()  # 删除重复值
    
    # 统计分析
    print("\\n数值列统计:")
    print(df.describe())
    
    # 分组统计
    grouped = df.groupby('category')['amount'].sum()
    print("\\n分类汇总:")
    print(grouped)
    
    # 可视化
    grouped.plot(kind='bar')
    plt.title('Category Amount')
    plt.xlabel('Category')
    plt.ylabel('Amount')
    plt.show()
    
    return df

# 使用示例
if __name__ == '__main__':
    data = analyze_data('data.csv')''',
    ),
    CodeExample(
      id: '5',
      title: '简单的网页爬虫',
      description: '使用 requests 和 BeautifulSoup 爬取网页数据',
      language: 'python',
      category: '爬虫',
      createdAt: DateTime.now(),
      code: '''import requests
from bs4 import BeautifulSoup
import json

def scrape_news(url):
    try:
        # 发送请求
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        response = requests.get(url, headers=headers)
        response.encoding = 'utf-8'
        
        # 解析 HTML
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # 提取数据
        news_list = []
        articles = soup.find_all('article', class_='news-item')
        
        for article in articles:
            title = article.find('h2').text.strip()
            link = article.find('a')['href']
            summary = article.find('p', class_='summary')
            summary_text = summary.text.strip() if summary else ''
            
            news_list.append({
                'title': title,
                'link': link,
                'summary': summary_text
            })
        
        # 保存为 JSON
        with open('news.json', 'w', encoding='utf-8') as f:
            json.dump(news_list, f, ensure_ascii=False, indent=2)
        
        print(f"成功爬取 {len(news_list)} 条新闻")
        return news_list
        
    except Exception as e:
        print(f"爬取失败: {e}")
        return []

# 使用示例
if __name__ == '__main__':
    scrape_news('https://example.com/news')''',
    ),
    // JavaScript 示例
    CodeExample(
      id: '6',
      title: '数组常用操作',
      description: 'JavaScript 数组的 map、filter、reduce 用法',
      language: 'javascript',
      category: '基础语法',
      createdAt: DateTime.now(),
      code: '''// 示例数据
const users = [
  { id: 1, name: 'Alice', age: 25, role: 'admin' },
  { id: 2, name: 'Bob', age: 30, role: 'user' },
  { id: 3, name: 'Charlie', age: 35, role: 'user' },
  { id: 4, name: 'Diana', age: 28, role: 'admin' },
];

// 1. map - 转换数组
const names = users.map(user => user.name);
console.log('Names:', names); 
// ['Alice', 'Bob', 'Charlie', 'Diana']

// 2. filter - 筛选数组
const adults = users.filter(user => user.age >= 30);
console.log('Adults:', adults);

// 3. find - 查找单个元素
const alice = users.find(user => user.name === 'Alice');
console.log('Alice:', alice);

// 4. reduce - 累加计算
const totalAge = users.reduce((sum, user) => sum + user.age, 0);
console.log('Total age:', totalAge); // 118

// 5. 链式操作
const adminNames = users
  .filter(user => user.role === 'admin')
  .map(user => user.name)
  .join(', ');
console.log('Admins:', adminNames); 
// 'Alice, Diana'

// 6. some / every - 判断
const hasAdult = users.some(user => user.age >= 30); // true
const allAdults = users.every(user => user.age >= 20); // true''',
    ),
    CodeExample(
      id: '7',
      title: 'Fetch API 请求封装',
      description: '封装 fetch 请求，支持 GET/POST 和错误处理',
      language: 'javascript',
      category: '网络请求',
      createdAt: DateTime.now(),
      code: '''class HttpClient {
  constructor(baseURL) {
    this.baseURL = baseURL;
    this.headers = {
      'Content-Type': 'application/json',
    };
  }

  // 设置 token
  setToken(token) {
    this.headers['Authorization'] = `Bearer \${token}`;
  }

  // GET 请求
  async get(endpoint) {
    try {
      const response = await fetch(`\${this.baseURL}\${endpoint}`, {
        method: 'GET',
        headers: this.headers,
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: \${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('GET request failed:', error);
      throw error;
    }
  }

  // POST 请求
  async post(endpoint, data) {
    try {
      const response = await fetch(`\${this.baseURL}\${endpoint}`, {
        method: 'POST',
        headers: this.headers,
        body: JSON.stringify(data),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: \${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('POST request failed:', error);
      throw error;
    }
  }
}

// 使用示例
const api = new HttpClient('https://api.example.com');

// 设置 token
api.setToken('your-jwt-token');

// 发起请求
async function loadData() {
  try {
    const users = await api.get('/users');
    console.log('Users:', users);
    
    const newUser = await api.post('/users', {
      name: 'John',
      email: 'john@example.com'
    });
    console.log('Created:', newUser);
  } catch (error) {
    console.error('Error:', error);
  }
}

loadData();''',
    ),
  ];
}
