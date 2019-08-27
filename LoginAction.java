package com.internousdev.texas.action;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.internousdev.texas.dao.CartInfoDAO;
import com.internousdev.texas.dao.UserInfoDAO;
import com.internousdev.texas.dto.CartInfoDTO;
import com.internousdev.texas.dto.UserInfoDTO;
import com.internousdev.texas.util.InputChecker;
import com.opensymphony.xwork2.ActionSupport;

public class LoginAction extends ActionSupport implements SessionAware{

	private String userId;//入力されたユーザーID
	private String password;//入力されたパスワード
	private List<CartInfoDTO> cartInfoList = new ArrayList<CartInfoDTO>(); //カート情報
	private String isNotUserInfoMessage; //ユーザー情報がない場合のメッセージ
	private List<String> userIdErrorMessageList;//ユーザIDにエラーがある場合のメッセージ
	private List<String> passwordErrorMessageList;//パスワードにエラーがある場合のメッセージ
	private Map<String, Object> session;//セッション
	private boolean savedUserIdFlag;//ユーザーID保存チェック
	private int totalPrice;

	public String execute(){
		String result = ERROR;
		/* セッションに入っている仮ユーザーIDの有効時間は30分間のため、
		 * 有効でなくなった場合は、セッションタイムアウトとなる */
		if(!session.containsKey("tempUserId")){
			return "sessionTimeout";
		}
		/* ユーザー登録画面で登録完了後、LoginActionに遷移しログイン認証を行うため、
		 * ユーザー登録時にセッションに保存された情報は不要となるため削除する */
		if(session.containsKey("createUserFlag")){
			userId = session.get("userIdForCreateUser").toString();
			password = session.get("password").toString();

			session.remove("userIdForCreateUser");
			session.remove("password");
			session.remove("familyName");
			session.remove("firstName");
			session.remove("familyNameKana");
			session.remove("firstNameKana");
			session.remove("sex");
			session.remove("sexList");
			session.remove("email");
			session.remove("createUserFlag");

		}
		//前回までにセッションに保存されたユーザーID保存チェックフラグを削除する
		session.remove("savedUserIdFlag");
		//入力チェック
		InputChecker inputChecker = new InputChecker();
		//ユーザーIDの入力チェック
		userIdErrorMessageList = inputChecker.doCheck("ユーザーID", userId, 1, 8, true, false, false, true, false, false);
		//パスワードの入力チェック
		passwordErrorMessageList = inputChecker.doCheck("パスワード", password, 1, 16, true, false, false, true, false, false);

		// 何かエラーメッセージがある場合はログイン済みにせずに、再度ログイン画面を表示
		if(userIdErrorMessageList.size()>0 || passwordErrorMessageList.size()>0){
			session.put("logined", 0);
			return result;
		}

		//ログイン成功時の処理
		UserInfoDAO userInfoDAO = new UserInfoDAO();
		if(userInfoDAO.isExistsUserInfo(userId,password) && userInfoDAO.login(userId, password)>0){
			CartInfoDAO cartInfoDAO = new CartInfoDAO();

			//ログイン前に付与されていた仮ユーザーIDのカートの情報を紐付ける。
			String tempUserId = session.get("tempUserId").toString();
			List<CartInfoDTO> cartInfoDTOListForTempUser = cartInfoDAO.getCartInfoList(tempUserId);
			//カート情報が存在する場合
			if(cartInfoDTOListForTempUser !=null){
				boolean cartresult = changeCartInfo(cartInfoDTOListForTempUser, tempUserId);
				if(!cartresult){
					return "DBError";
				}
			}

	//次の遷移先
		/* カート画面から遷移してきた場合はcartFlgを所持しているため、ループにならないように
		 * セッション内のcartFlgを削除してからカート画面に戻る。 */
		if(session.containsKey("cartFlag")){
			session.remove("cartFlag");
			result = "cart";

		//カート画面から遷移してきていない場合はホーム画面に戻る
		}else{
			result=SUCCESS;
		}

		/* ログインに成功したユーザー情報はカート情報紐付けや決済等に必要となるためをセッションに登録する。
		 * ログイン後は自動付与されていた仮ユーザーIDは不要になるため削除する */
		UserInfoDTO userInfoDTO = userInfoDAO.getUserInfo(userId,password);
		session.put("userId",userInfoDTO.getUserId());
		session.put("logined", 1);

		//ログインIDを残すかどうかを判断するためにフラグをつける
		if(savedUserIdFlag){
			session.put("savedUserIdFlag", true);
		}
		session.remove("tempUserId");
		}else{
			isNotUserInfoMessage="ユーザーIDまたはパスワードが異なります。";
		}
		return result;
		}

	private boolean changeCartInfo(List<CartInfoDTO> cartInfoDTOListForTempUser, String tempUserId){
		int count= 0;
		CartInfoDAO cartInfoDAO = new CartInfoDAO();
		boolean result = false;

		for(CartInfoDTO dto : cartInfoDTOListForTempUser){
			if(cartInfoDAO.isExistsCartInfo(userId,dto.getProductId())){
				//今回追加した商品と同じ商品IDの商品がカート情報に存在する場合は、重複表示をせずに個数を足して表示させる
				count += cartInfoDAO.updateProductCount(userId,dto.getProductId(),dto.getProductCount());
				//仮ユーザーIDのカート情報は不要となるため削除する
				cartInfoDAO.delete(tempUserId, String.valueOf(dto.getProductId()));
			}else{
				/* 同じ商品IDの商品がカート情報に存在しない場合は、仮ユーザーIDに紐付くカート情報を
				 * ユーザーIDに紐付けて、カート情報を更新する */
				count += cartInfoDAO.linkToUserId(tempUserId, userId, dto.getProductId());
				}
			}
		if(count == cartInfoDTOListForTempUser.size()){
			cartInfoList = cartInfoDAO.getCartInfoList(userId);
			totalPrice = cartInfoDAO.getTotalPrice(userId);
			result = true;
		}
		return result;
	}

	public String getUserId(){
		return userId;
	}
	public void setUserId(String userId){
		this.userId=userId;
	}
	public String getPassword(){
		return password;
	}
	public void setPassword(String password){
		this.password=password;
	}
	public String getIsNotUserInfoMessage(){
		return isNotUserInfoMessage;
	}
	public void setIsNotUserInfoMessage(String isNotUserInfoMessage){
		this.isNotUserInfoMessage=isNotUserInfoMessage;
	}
	public Map<String,Object> getSession(){
		return session;
	}
	public void setSession(Map<String,Object> session){
		this.session=session;
	}
	public boolean getSavedUserIdFlag(){
		return savedUserIdFlag;
	}
	public void setSavedUserIdFlag(boolean savedUserIdFlag){
		this.savedUserIdFlag=savedUserIdFlag;
	}
	public int getTotalPrice(){
		return totalPrice;
	}
	public void setTotalPrice(int totalPrice){
		this.totalPrice=totalPrice;
	}
	public List<CartInfoDTO> getCartInfoList(){
		return cartInfoList;
	}
	public void setCartInfoList(List<CartInfoDTO> cartInfoList){
		this.cartInfoList=cartInfoList;
	}
	public List<String> getUserIdErrorMessageList(){
		return userIdErrorMessageList;
	}
	public void setUserIdErrorMessageList(List<String> userIdErrorMessageList){
		this.userIdErrorMessageList=userIdErrorMessageList;
	}
	public List<String> getPasswordErrorMessageList(){
		return passwordErrorMessageList;
	}
	public void setPasswordErrorMessageList(List<String> passwordErrorMessageList){
		this.passwordErrorMessageList=passwordErrorMessageList;
	}

}
