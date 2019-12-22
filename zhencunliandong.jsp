<tr>
	<td class="td_label"><div align="right">镇:</div></td>
	<td>
		<input type="hidden" name="TownshipCode"  id="TownshipCode" value="<%=v.getTownCode()%>" />
		<input editable="true" name="TownCode" id="TownCode"  class="easyui-textbox"  data-options="required:true">
	</td>
</tr>
<tr>
	<td class="td_label"><div align="right">村:</div></td>
	<td>
		<input type="hidden" name="XzVillageCode"  id="XzVillageCode"  value="<%=v.getVillageCode()%>">
		<input editable="true" name="VillageCode" id="VillageCode"  class="easyui-textbox"  data-options="required:true">
	</td>
</tr>
3.js部分初始化镇和村的单选框数据:
$(function() {
	//镇
	 $("#TownCode").combobox({  
	       valueField: 'code',  
	       textField: 'Name',  
	       url: '../../infochaxun.jsp?showFlag=chaxun&zhenId='+zhenId,
	        editable:true,
	        mode:'local',
	  		filter: function(q, row){
	  		var opts = $(this).combobox('options');
	  		return row[opts.textField].indexOf(q) >= 0;
	  		},
	     	onLoadSuccess: function () { 
	        	 var data = $('#TownCode').combobox('getData');
	        	 for(var chk in data){
		           	 if (data[chk].code == zhenId) {		           		           	  	select2(zhenId);
		           	 } 
	        	 } 
	        },
	     	 onSelect:function(r){	  	    	
	  	    	select2(r.code);
	     	 }
		    }),
	 //村
	$("#VillageCode").combobox({  
	    valueField: 'code',  
	    textField: 'Name' 
	})	
})
 function select2(code){
	var code = code;
	$("#VillageCode").combobox({  
       valueField: 'code',  
       textField: 'Name',  
        url: '../../infochaxun.jsp?showFlag=coutury&code='+code+'&cunId='+cunId, 
        mode:'local',
 		filter: function(q, row){
 		var opts = $(this).combobox('options');
 		return row[opts.textField].indexOf(q) >= 0;
 	} 
   })   
} 
4.在../../infochaxun中单选框获取写数据字典
String showFlag = ParamUtils.getParameter(request,"showFlag","");
List row = new ArrayList();
List cdt =new ArrayList();
if(showFlag.equals("chaxun")){//查询
	TownVillage tv = new TownVillage();
	String zhenId = ParamUtils.getParameter(request,"zhenId","");
	cdt.add("pid=1");
	cdt.add("DelFlag='0'");
	cdt.add("order by orderNum asc");
	List<TownVillage> tvs = tv.query(cdt);
	if(tvs.size()>0){
		for(int i = 0;i<tvs.size();i++){
			Map tempMap = new HashMap();
			tv = tvs.get(i);
			tempMap.put("code",tv.getCode());
			tempMap.put("Name",tv.getTitle());	
			if(tv.getCode().equals(zhenId)&&!tv.getCode().equals(""))
			{
				tempMap.put("selected",true);//默认值
			} 
			row.add(tempMap);			
		}
	}
	out.clear();
	out.print(JSON.toJSONString(row));	
}else if(showFlag.equals("coutury")){//村
	cdt.clear();
	String code = ParamUtils.getParameter(request,"code","");
	String cunId = ParamUtils.getParameter(request,"cunId","");
	TownVillage tv = new TownVillage();
	if(!code.equals("")){
		cdt.add("pid=(select id from tbl_townvillage where code='"+code+"')");
	}
	cdt.add("pid !=1");
	cdt.add("pid !=0");
	cdt.add("DelFlag='0'");
	cdt.add("order by OrderNum");	
	List<TownVillage> tvs = tv.query(cdt);
	if(tvs.size()>0){
		for(int i = 0;i<tvs.size();i++){
			Map tempMap = new HashMap();
			tv = tvs.get(i);
			tempMap.put("code",tv.getCode());
			tempMap.put("Name",tv.getTitle());		
			if(tv.getCode().equals(cunId)&&!tv.getCode().equals(""))
			{
				tempMap.put("selected",true);//默认值
			} 
			row.add(tempMap);			
		}
	}
	out.clear();
	out.print(JSON.toJSONString(row));
}