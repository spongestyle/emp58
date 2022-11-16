package vo;

public class Salary {
    // public int empNo; // 테이블 컬럼과 일치, 단점은 조인결과를 처리할 수 없다
	public Employee emp; // inner join 결과물을 저장하기 위해서
	public int salary;
	public String fromDate;
	public String toDate;
}