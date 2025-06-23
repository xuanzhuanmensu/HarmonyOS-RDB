import { BusinessError } from '@ohos.base';
import { relationalStore, ValuesBucket } from '@kit.ArkData'; // 导入模块

interface  Employee  extends ValuesBucket{
  id: number|null;    // 可选属性，因为插入时自动生成
  name: string
  age: number
  salary: number
  Codes: string
}

const SQL_CREATE_TABLE = `
  CREATE TABLE IF NOT EXISTS EMPLOYEE (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    NAME TEXT NOT NULL,
    AGE INTEGER,
    SALARY REAL,
    Codes TEXT
  )`;

@Entry
@Component
struct Index {
  @State employees: Employee[] = [];
  private rdbStore: relationalStore.RdbStore | null = null;

  // 生命周期 - 页面初始化
  aboutToAppear() {
    this.initRdbStore();
  }

  // 初始化数据库
  private async initRdbStore() {
    try {
      this.rdbStore = await relationalStore.getRdbStore(getContext(), {
        name:'harmonyos.db',
        securityLevel:relationalStore.SecurityLevel.S1
      });
      await this.rdbStore.executeSql(SQL_CREATE_TABLE);
      console.info('Table created successfully');
      this.query(); // 初始数据加载
    } catch (err) {
      console.error(`Database init failed: ${JSON.stringify(err)}`);
    }
  }

  // 增加数据
  async insert() {
    if (!this.rdbStore) return;

    const employee: Employee = {
      id:null,
      name: 'zz',
      age: 18,
      salary: 100.86,
      Codes: '鸿蒙'
    } ;

    try {
      const rowId = await this.rdbStore.insert("EMPLOYEE", employee);
      console.info(`Insert success, rowId: ${rowId}`);
      employee.id = rowId;
      this.employees = [...this.employees, employee];
    } catch (err) {
      this.handleError(err as BusinessError, 'Insert');
    }
  }

  // 删除数据
  async remove() {
    if (!this.rdbStore) return;

    const predicates = new relationalStore.RdbPredicates("EMPLOYEE");
    predicates.equalTo("ID", 2); // 删除ID为2的记录

    try {
      const affectedRows = await this.rdbStore.delete(predicates);
      console.info(`Deleted ${affectedRows} rows`);
      this.query(); // 删除后刷新
    } catch (err) {
      this.handleError(err as BusinessError, 'Delete');
    }
  }

  // 修改数据
  async update() {

    if (!this.rdbStore) return;

    const updateValues : ValuesBucket= {
      Codes: 'Java' // 只更新需要的字段
    };

    const predicates = new  relationalStore.RdbPredicates("EMPLOYEE");
    predicates.equalTo('NAME', 'zz');

    try {
      const affectedRows = await this.rdbStore.update(updateValues, predicates);
      console.info(`Updated ${affectedRows} rows`);
      this.query();
    } catch (err) {
      this.handleError(err as BusinessError, 'Update');
    }
  }

  // 查询数据
  async query() {
    if (!this.rdbStore) return;

    const predicates = new relationalStore.RdbPredicates("EMPLOYEE");
    const columns = ["ID", "NAME", "AGE", "SALARY", "Codes"];

    try {
      const resultSet = await this.rdbStore.query(predicates, columns);
      this.processResultSet(resultSet);
    } catch (err) {
      this.handleError(err as BusinessError, 'Query');
    }
  }

  // 处理查询结果
  private processResultSet(resultSet:  relationalStore.ResultSet) {
    const temp: Employee[] = [];
    if (resultSet.rowCount > 0) {
      while (resultSet.goToNextRow()) {
        temp.push({
          id: resultSet.getLong(0),
          name: resultSet.getString(1),
          age: resultSet.getLong(2),
          salary: resultSet.getDouble(3),
          Codes: resultSet.getString(4)
        });
      }
    }
    resultSet.close(); // 必须关闭结果集
    this.employees = [...temp];
  }

  // 统一错误处理
  private handleError(err: BusinessError, operation: string) {
    console.error(`${operation} failed: Code=${err.code}, Message=${err.message}`);
  }

  // UI布局
  build() {
    Column() {
      // 标题
      Text('关系型数据库增删改查操作')
        .fontSize(22)
        .margin(10)
        .fontColor(Color.Black)

      // 操作按钮
      this.buildActionButtons()

      // 数据表格
      this.buildDataTable()
    }
    .width('100%')
    .height('100%')
    .padding(12)
  }

  @Builder
  buildActionButtons() {
    Row() {
      Button('添加')
        .onClick(() => this.insert())
        .type(ButtonType.Capsule)

      Button('删除')
        .onClick(() => this.remove())
        .type(ButtonType.Capsule)
        .margin({ left: 10 })

      Button('修改')
        .onClick(() => this.update())
        .type(ButtonType.Capsule)
        .margin({ left: 10 })

      Button('查看')
        .onClick(() => this.query())
        .type(ButtonType.Capsule)
        .margin({ left: 10 })
    }
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 20 })
  }

  @Builder
  buildDataTable() {
    Column() {
      // 表头
      this.buildTableHeader()

      // 数据行
      List({ space: 8 }) {
        ForEach(this.employees, (item: Employee) => {
          ListItem() {
            this.buildTableRow(item)
          }
        }, (item: Employee) => item.id?.toString() ?? '')
      }
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: Color.Gray })
    }
    .borderRadius(8)
    .border({ width: 1, color: Color.Gray })
    .padding(8)
  }

  @Builder
  buildTableHeader() {
    Row() {
      TableCell({content:'序号',flexWeight:1})
      TableCell({content:'姓名',flexWeight:2})
      TableCell({content:'年龄',flexWeight:1})
      TableCell({content:'工资',flexWeight:2})
      TableCell({content:'Codes',flexWeight:4})
    }
    .width('100%')
    .padding(8)
  }

  @Builder
  buildTableRow(employee: Employee) {
    Row() {
      TableCell({content:employee.id?.toString(),flexWeight:1})
      TableCell({content:employee.name,flexWeight:2})
      TableCell({content:employee.age.toString(),flexWeight:1})
      TableCell({content:employee.salary.toFixed(2),flexWeight:2})
      TableCell({content:employee.Codes,flexWeight:4})
    }
    .width('100%')
    .padding(8)
  }
}

// 可复用表格单元格组件
@Component
struct TableCell {
  @Prop content: string = '';
  @Prop flexWeight: number = 1;

  build() {
    Text(this.content)
      .fontSize(16)
      .textAlign(TextAlign.Start)
      .layoutWeight(1)
      .margin({ right: 8 })
  }
}